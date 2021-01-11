# shellcheck shell=sh

Describe 'Default Lokl website'
  Describe 'WP2Static'
    It 'generates zip of exported site files when'
      
      configure_wp2static() {
        # use spec helper for common commands
        # create_lokl_site

        # delete existing test container
        docker rm -f lokltestsite

        # run new container
        export lokl_php_ver=php7
        export lokl_site_name=lokltestsite
        export lokl_site_port=4444

        echo 'something ' >> /tmp/testlog

        env | grep lokl_ >> /tmp/testlog

        wget 'https://raw.githubusercontent.com/leonstafford/lokl-cli/master/cli.sh'

        sh cli.sh 

        docker exec -it lokltestsite sh -c \
          "wp wp2static addons enable wp2static-addon-zip &&" \
          "wp wp2static options set deployment_method zip &&" \
          "wp wp2static detect && wp wp2static crawl &&" \
          "wp wp2static post_process && wp wp2static deploy"
      }
      
      zip_file_present() {
        processed_site_zip="http://localhost:4444/wp-content/uploads/wp2static-processed-site.zip"


        # TODO: checks on the zip (size, num files, index content?)  
        if wget -q --method=HEAD "$processed_site_zip";
         then
          echo 'found processed zip ' >> /tmp/testlog
          return 0
         else
          echo 'NO processed zip ' >> /tmp/testlog
          return 1
        fi
      }
      
     When call configure_wp2static
     The output should include 'Finished processing crawled site'
     The result of function zip_file_present should be success
    End
  End
End
