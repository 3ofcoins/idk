name "file"
version '5.17'

dependency "zlib"

source url: "ftp://ftp.astron.com/pub/#{name}/#{name}-#{version}.tar.gz",
       md5: 'e19c47e069ced7b01ccb4db402cc01d3'
relative_path "#{name}-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  patch :source => 'getline.patch' # http://bugs.gw.com/view.php?id=230
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end
