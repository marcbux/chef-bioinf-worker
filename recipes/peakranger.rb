#
# Cookbook Name:: chef-bioinf-worker
# Recipe:: peakranger
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

peakranger_link = "http://downloads.sourceforge.net/project/ranger/PeakRanger-1.14-Linux-x86_64.zip"
peakranger_zip  = "#{node.default.dir.archive}/#{File.basename( peakranger_link )}"
peakranger_dir  = "#{node.default.dir.software}/PeakRanger-1.14-Linux-x86_64"




directory node.default.dir.software
directory node.default.dir.archive

package "unzip"

remote_file peakranger_zip do
    action :create_if_missing
    source peakranger_link
end

bash "extract_peakranger" do
    code "unzip -o #{peakranger_zip} -d #{peakranger_dir}"
    not_if "#{Dir.exists?( peakranger_dir )}"
end

link "#{node.default.dir.bin}/ranger" do
    to "#{peakranger_dir}/ranger"
end