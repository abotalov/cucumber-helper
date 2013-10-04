require 'cucumber/formatter/console'
require 'cucumber/formatter/ansicolor'
require 'cucumber/formatter/io'
require 'ruby-progressbar'

module Cucumber
  module Formatter
    class CuckeBar

      include Io
      include Console

      attr_reader :runtime
    
      def initialize(runtime, path_or_io, options)
        @runtime, @io, @options = runtime, ensure_io(path_or_io, 'cucumber-helper'), options
        @step_count = @issues_count = 0
      end

      def before_features(features)
        @steps_count = steps_count(features)
        @progress_bar = ProgressBar.create(format: ' %c/%C |%w>%i| %e ', total: @steps_count, output: @io)
      end

      def after_features(features)
        @state = :red if runtime.scenarios(:failed).any?
        @io.puts
        @io.puts

        print_stats(features, @options)
        print_snippets(@options)
        print_passing_wip(@options)
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        @state = :red if status == :failed
        if exception and [:failed, :undefined].include? status
          @io.print "\e[K" if color_enabled?
          @issues_count += 1
          @io.puts
          @io.puts "#{@issues_count})"
          print_exception(exception, status, 2)
          @io.puts
          @io.flush
        end
        progress status
      end

      private

      def steps_count(features)
        count = 0
        features = features.instance_variable_get('@features')
        features.each do |feature|

          scenarios_number = 0

          feature.instance_variable_get('@feature_elements').each do |scenario|
            scenario_size = scenario.raw_steps.size

            examples = scenario.instance_variable_get('@example_sections')
            if examples
              examples.each do |example|
                matrix_size = example.last.instance_variable_get('@rows').size
                count += scenario_size * (matrix_size - 1)
                scenarios_number += matrix_size - 1
              end
            else
              count += scenario_size
              scenarios_number += 1
            end
          end

          background = feature.instance_variable_get('@background')
          if background.instance_of?(Cucumber::Ast::Background)
            background_size = background.raw_steps.size
            count += scenarios_number * background_size
          end
        end

        count
      end

      COLORS = { passed: "\e[32m", skipped: "\e[33m", failed: "\e[31m" }

      def progress(state = :passed, count = 1)
        choose_color(COLORS[state]) do
          @progress_bar.progress += count
        end
      end

      def choose_color(color, &block)
        @io.print color if color_enabled?
        yield
        @io.print "\e[0m" if color_enabled?
      end

      def color_enabled?
        Cucumber::Term::ANSIColor.coloring?
      end

    end
  end
end
