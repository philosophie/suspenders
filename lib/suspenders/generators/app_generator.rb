require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Suspenders
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_heroku, type: :boolean, aliases: "-H", default: false,
      desc: "Don't create staging and production Heroku apps"

    class_option :heroku_flags, type: :string, default: "",
      desc: "Set extra Heroku flags"

    class_option :github, type: :string, aliases: "-G", default: nil,
      desc: "Create Github repository and add remote origin pointed to repo"

    class_option :origin, type: :string, default: nil,
      desc: "Add and push to git remote for origin"

    class_option(
      :css_framework,
      type: :string,
      aliases: "-C",
      default: nil,
      desc: "Install a css framework "\
            "(options: bourbon_n_friends/bootstrap/foundation)"
    )

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :skip_git, type: :boolean, default: false,
      desc: "Don't create and commit to git repository"

    def initialize(*args)
      super

      if options[:webpack] && `which yarn`.empty?
        raise Rails::Generators::Error, 'ERROR: yarn is required in order to use webpack'
      end
    end

    def finish_template
      invoke :suspenders_customization
      super
    end

    def suspenders_customization
      invoke :copy_project_markdown_files
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :setup_secret_token
      invoke :create_suspenders_views
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :setup_javascripts
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_routes_comment_lines
      invoke :setup_git
      invoke :setup_database
      invoke :create_heroku_apps
      invoke :create_github_repo
      invoke :setup_segment
      invoke :setup_bundler_audit
      invoke :setup_spring
      invoke :run_stairs
      invoke :initial_commit_and_branching
      invoke :push_to_origin
      invoke :setup_css_framework
      invoke :outro
    end

    def copy_project_markdown_files
      build :readme
      build :pull_request_template
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used
      build :add_webpacker if options[:webpack]

      unless options[:skip_heroku]
        build :setup_heroku_specific_gems
      end

      bundle_command 'install'

      build :version_gems_in_gemfile
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :set_test_delivery_method
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :configure_generators
      build :configure_i18n_for_missing_translations
      build :configure_rubocop
      build :configure_quiet_assets
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :generate_rspec
      build :configure_rspec
      build :enable_database_cleaner
      build :configure_spec_support_features
      build :configure_i18n_for_test_environment
      build :configure_i18n_tasks
      build :configure_action_mailer_in_specs
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_newrelic
      build :configure_smtp
      build :enable_rack_canonical_host
      build :configure_production_log_level
      build :enable_rack_deflater
      build :setup_asset_host
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
      build :setup_secret_token
    end

    def create_suspenders_views
      say 'Creating suspenders views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
    end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :configure_active_job
      build :configure_time_formats
      build :configure_simple_form
      build :fix_i18n_deprecation_warning
      build :setup_default_rake_task
      build :configure_puma
      build :setup_foreman
      build :configure_airbrake
      build :configure_lib_directory
    end

    def setup_stylesheets
      say 'Set up stylesheets'
      build :setup_stylesheets
    end

    def setup_javascripts
      say 'Set up javascript'
      build :setup_javascripts
      build :inject_webpacker_into_layout if options[:webpack]
    end

    def setup_css_framework
      if options[:css_framework]
        say "Installing #{options[:css_framework]}"
        case options[:css_framework]
        when 'bourbon_n_friends' then build :install_bourbon_n_friends
        when 'bootstrap' then build :install_bootstrap
        when 'foundation' then build :install_foundation
        else say "Unrecognized Css Framework"
        end
      end
    end

    def setup_git
      if !options[:skip_git]
        say 'Initializing git'
        invoke :setup_gitignore
        invoke :init_git
      end
    end

    def initial_commit_and_branching
      if !options[:skip_git]
        say 'Creating initial commit and branches'
        build :create_initial_commit
        build :setup_deployment_environment_branches
      end
    end

    def push_to_origin
      if !options[:skip_git] && options[:origin]
        say 'Pushing to origin remote'
        build :setup_and_push_to_origin_remote, options[:origin]
      end
    end

    def create_heroku_apps
      unless options[:skip_heroku]
        say "Creating Heroku apps"
        build :create_heroku_apps, options[:heroku_flags]
        build :set_heroku_serve_static_files
        build :set_heroku_rails_secrets
      end
    end

    def create_github_repo
      if !options[:skip_git] && options[:github]
        say 'Creating Github repo'
        build :create_github_repo, options[:github]
      end
    end

    def setup_segment
      say 'Setting up Segment'
      build :setup_segment
    end

    def setup_gitignore
      build :gitignore_files
    end

    def setup_bundler_audit
      say "Setting up bundler-audit"
      build :setup_bundler_audit
    end

    def setup_spring
      say "Springifying binstubs"
      build :setup_spring
    end

    def init_git
      build :init_git
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def run_stairs
      build :run_stairs
    end

    def outro
      say 'Congratulations! You just pulled our suspenders.'
      say 'Remember to update the README with specifics for your project.'
    end

    protected

    def get_builder_class
      Suspenders::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
