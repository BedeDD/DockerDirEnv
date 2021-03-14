# frozen_string_literal: true

require 'rails/generators/base'

module DockerDirEnv
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__).times

      desc 'Copies .envrc, docker-db-setup.sh and a new database.yml to the project'
      public_task :install

      # Installs the required files in the application
      def install
        copy_envrc
        copy_database_yml
        copy_docker_db_setup_sh
        system(`direnv allow`)
      end

      private

      def copy_envrc
        copy_file('.envrc', '.envrc')
      end

      def copy_database_yml

      end

      def copy_docker_db_setup_sh

      end
    end
  end
end