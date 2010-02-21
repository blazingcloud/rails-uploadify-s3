module UploadifyS3
  require 'uploadify_s3_helper'
  ActionView::Base.send :include, UploadifyS3Helper
end