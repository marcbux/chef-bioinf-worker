#
# Cookbook Name:: chef-bioinf-worker
# Recipe:: randfold
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

include_recipe "chef-bioinf-worker::squid"

randfold_link = "http://bioinformatics.psb.ugent.be/supplementary_data/erbon/nov2003/downloads/randfold-2.0.tar.gz"
randfold_tar  = "#{node.dir.archive}/#{File.basename( randfold_link )}"
randfold_dir  = "#{node.dir.software}/randfold-2.0"



remote_file randfold_tar do
    action :create_if_missing
    source randfold_link
    retries 1
end

bash "extract_randfold" do
    code "tar xf #{randfold_tar} -C #{node.dir.software}"
    not_if "#{Dir.exists?( randfold_dir )}"
end

bash "compile_randfold" do
    code "make INCLUDE=\"-I. -I#{node.dir.squid} -L#{node.dir.squid}/\""
    cwd randfold_dir
    not_if "#{File.exists?( "#{randfold_dir}/randfold" )}"
end

link "#{node.dir.bin}/randfold" do
  to "#{randfold_dir}/randfold"
end

