module Capistrano
  module Deploy
    module Confirm
      def ensure_revision inform_user = false
        if test "[ -f #{current_path}/REVISION ]"
          yield
        else
          warn "\e[0;31mSkipping pending changes check on #{host} (no REVISION file found)\e[0m" if inform_user
          return false
        end
        return true
      end

      def from_rev
        within current_path do
          current_revision = capture(:cat, "REVISION")

          run_locally do
            return capture(:git, "name-rev --always --name-only #{current_revision}") # find symbolic name for ref
          end
        end
      end

      def to_rev
        run_locally do
          to = fetch(:branch)

          # get target branch upstream if there is one
          if test(:git, "rev-parse --abbrev-ref --symbolic-full-name #{to}@{u}")
            to = capture(:git, "rev-parse --abbrev-ref --symbolic-full-name #{to}@{u}")
          end

          # find symbolic name for revision
          to = capture(:git, "name-rev --always --name-only #{to}")
        end
      end
    end
  end
end

load File.expand_path('../tasks/deploy-confirm.rake', __FILE__)