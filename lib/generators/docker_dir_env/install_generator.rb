# frozen_string_literal: true

require 'rails/generators/base'
require 'erb'

module DockerDirEnv
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Copies .envrc, docker-db-setup.sh and a new database.yml to the project'
      public_task :install

      # Installs the required files in the application
      def install
        copy_envrc
        copy_database_yml
        copy_docker_db_setup_sh
        system(`direnv allow`)
        print("#{readme}\n")
      end

      private

      def copy_envrc
        @app_name = Rails.application.class.name&.deconstantize&.underscore
        template('.envrc', '.envrc')
      end

      def copy_database_yml
        template('config/database.yml', 'config/database.yml')
      end

      def copy_docker_db_setup_sh
        FileUtils.mkdir_p('lib/scripts')
        copy_file('lib/scripts/docker-db-setup.sh', 'lib/scripts/docker-db-setup.sh')
        system(`chmod +x lib/scripts/docker-db-setup.sh`)
      end

      def readme
        <<~README
          Thanks for using docker_dir_env!
          Make sure to provide the databases credentials by configuring them with
          `EDITOR=vim rails credentials:edit` OR
          `EDITOR=vim rails credentials:edit -e development` (and the other envs)

           Your can use your favourite editor instead of vim.

          Provide the following structure inside the credentials:
          database:
            username: YOUR_USERNAME
            password: YOUR_PASSWORD
        README
      end
    end
  end
end