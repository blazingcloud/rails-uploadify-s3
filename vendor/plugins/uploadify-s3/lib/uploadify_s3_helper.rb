module UploadifyS3Helper
  
  def javascript_uploadify_s3_tag(options = {})
    options = default_options.merge(options)
    javascript_tag( %(
  		$(document).ready(function() {
  			$("#{options[:file_input_selector]}").uploadify({
  				'fileDataName' : 'file',
  				'uploader'       : '/flash/uploadify/uploadify.swf',
  				'script'         : '#{bucket_url}',
  				'cancelImg'      : '/images/uploadify/cancel.png',
  				'folder'         : '#{upload_path}',
  				'auto'           : true,
  				'multi'          : false,
  				'buttonText'		 : '#{options[:button_text]}',
  				'sizeLimit'			 : '#{max_filesize}',
  				'fileDesc'		   : '#{options[:file_desc]}',				
  				'fileExt'				 : '#{options[:file_ext]}',
  				'onError' 			 : function (a, b, c, d) {
  					if (d.info == 201) {
  					  var onsucc = (#{options[:on_success]});
  					  onsucc(c);
  						$('#{options[:file_input_selector]}').hide();
  						return false;
  					} else {
  						alert('error '+d.type+": "+d.text);
  					}
  				},				
          'scriptData' 		 : {
             'AWSAccessKeyId': '#{aws_access_key}',
             'key': '#{key}',
             'acl': '#{acl}',
             'policy': '#{s3_policy}',
  					 'success_action_status': '201',
             'signature': '#{s3_signature}',
        		 'Content-Type': ''
            }        
  			});
  		});
    ))
  end
  
  def uploadify_s3(options = {})
    stylesheet_link_tag('uploadify/uploadify') <<
    javascript_include_tag('uploadify/jquery.uploadify.v2.1.0.min') <<
    javascript_include_tag('uploadify/swfobject') <<
    javascript_uploadify_s3_tag(options)
  end
  
  def bucket_url
    "http://#{bucket}.s3.amazonaws.com/"
  end
  
  def key
    "#{upload_path}/${filename}"
  end
  
  def s3_policy
    policy_doc =   "{'expiration': '#{expiration_date}',
        'conditions': [
          {'bucket': '#{bucket}'},
          ['starts-with', '$key', '#{upload_path}/'],
          {'acl': '#{acl}'},
          ['content-length-range', 0, #{max_filesize}],
          {'success_action_status': '201'},
          ['starts-with','$folder',''],
          ['starts-with','$Filename',''],
          ['starts-with','$fileext',''],
        ]
      }"

      puts policy_doc
      Base64.encode64(policy_doc).gsub("\n","")
  end
 
  def s3_signature
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), aws_secret_key, s3_policy)).gsub("\n","")
  end

  private

  def config
     @config ||= load_config
   end
 
  def load_config
    YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml")
  end
  
  def aws_access_key
    config['access_key_id']
  end

  def aws_secret_key
    config['secret_access_key']
  end

  def bucket
    config['bucket_name']
  end
  
  def acl
    config['default_acl'] || "public-read"
  end
  
  def upload_path
    config['upload_path'] || 'uploads'
  end

  def max_filesize
    config['max_file_size'] || 50.megabyte
  end        
  
  def expiration_date
   10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
  end  
  
  def default_options
    {
      :button_text => 'Add File',
      :file_ext => '*.*',
      :file_input_selector => '#file_upload',
      :file_desc => 'Please choose your file'
      }
  end
  
end