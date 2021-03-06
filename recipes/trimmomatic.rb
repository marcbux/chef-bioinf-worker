#
# Cookbook Name:: chef-bioinf-worker
# Recipe:: trimmomatic
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

trimmomatic_link = "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.32.zip"
trimmomatic_zip  = "#{node.dir.archive}/#{File.basename( trimmomatic_link )}"
trimmomatic_dir  = "#{node.dir.software}/Trimmomatic-0.32"



include_recipe "chef-bioinf-worker::java"

package "unzip"

directory node.dir.software
directory node.dir.archive

remote_file trimmomatic_zip do
  action :create_if_missing
  source trimmomatic_link
  retries 1
end

bash "extract_trimmomatic" do
  code "unzip -o #{trimmomatic_zip} -d #{node.dir.software}"
  not_if "#{Dir.exists?( trimmomatic_dir )}"
end

file "#{node.dir.bin}/trimmomatic" do
  content <<-SCRIPT
#!/usr/bin/env bash
java -jar #{trimmomatic_dir}/trimmomatic-0.32.jar $@
  SCRIPT
  mode "0755"
end
