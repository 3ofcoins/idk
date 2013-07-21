name "file"
version '5.14'

dependency "zlib"

source url: "ftp://ftp.astron.com/pub/#{name}/#{name}-#{version}.tar.gz",
       md5: 'c26625f1d6773ad4bc5a87c0e315632c'
relative_path "#{name}-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end
