class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via ApacheNGINX"
  homepage "https:www.phusionpassenger.com"
  url "https:github.comphusionpassengerreleasesdownloadrelease-6.0.26passenger-6.0.26.tar.gz"
  sha256 "c69312230d4467a30d7a8abd25ee04250df3e332432871c6bd561ef5eea3d485"
  license "MIT"
  head "https:github.comphusionpassenger.git", branch: "stable-6.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33f50696f64c695f39c827ab92a7a5d91e57c45b5f4295e6c9a1200a8311e5b4"
    sha256 cellar: :any,                 arm64_sonoma:  "0fd5c9aed08ab6a9aaaba4d005adbd939b59e1f5d9239cd40964f258188d9ed8"
    sha256 cellar: :any,                 arm64_ventura: "0f61c3747b30b206fb1407c16538e0e967a8f2abc57d007e68465564f9d1290e"
    sha256 cellar: :any,                 sonoma:        "364199aeebe300bd34117627bc8810c7ffad9757950042376e86b31b03f98d71"
    sha256 cellar: :any,                 ventura:       "92f2c49e255621627198d45dc5338511e7989d4c3a80c7c7231856d620f411ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e67aee10ea7230e4e1600cc9769e41e9bfab959a1206958aebee15235b3cc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54d372a5982ddb7f04bd794f2aa7fde2e982a8c1e19a3e6c45667d023aba129"
  end

  depends_on "httpd" => :build # to build the apache2 module
  depends_on "nginx" => [:build, :test] # to build nginx module
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby", since: :catalina
  uses_from_macos "zlib"

  def install
    if OS.mac? && MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    else
      ENV.delete("SDKROOT")
    end

    inreplace "srcruby_supportlibphusion_passengerplatform_infoopenssl.rb" do |s|
      s.gsub! "-Iusrlocaloptopensslinclude", "-I#{Formula["openssl@3"].opt_include}"
      s.gsub! "-Lusrlocaloptopenssllib", "-L#{Formula["openssl@3"].opt_lib}"
    end

    system "rake", "apache2"
    system "rake", "nginx"
    nginx_addon_dir = `.binpassenger-config about nginx-addon-dir`.strip

    mkdir "nginx" do
      system "tar", "-xf", "#{Formula["nginx"].opt_pkgshare}srcsrc.tar.xz", "--strip-components", "1"
      args = (Formula["nginx"].opt_pkgshare"srcconfigure_args.txt").read.split("\n")
      args << "--add-dynamic-module=#{nginx_addon_dir}"

      system ".configure", *args
      system "make"
      (libexec"modules").install "objsngx_http_passenger_module.so"
    end

    (libexec"download_cache").mkpath

    # Fixes https:github.comphusionpassengerissues1288
    rm_r("buildoutlibev")
    rm_r("buildoutlibuv")
    rm_r("buildoutcache")

    necessary_files = %w[configure Rakefile README.md CONTRIBUTORS
                         CONTRIBUTING.md LICENSE CHANGELOG package.json
                         passenger.gemspec build bin doc images dev src
                         resources buildout]

    cp_r necessary_files, libexec, preserve: true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink Dir["#{libexec}bin*"]

    # Ensure that the Phusion Passenger commands can always find their library
    # files.

    locations_ini = `.binpassenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(=#{Regexp.escape Dir.pwd}, "=#{libexec}")
    (libexec"srcruby_supportlibphusion_passengerlocations.ini").write(locations_ini)

    ruby_libdir = `.binpassenger-config about ruby-libdir`.strip
    ruby_libdir.gsub!(^#{Regexp.escape Dir.pwd}, libexec)
    system ".devinstall_scripts_bootstrap_code.rb",
      "--ruby", ruby_libdir, *Dir[libexec"bin*"]

    # Recreate the tarball with a top-level directory, and use Gzip compression.
    mkdir "nginx-#{Formula["nginx"].version}" do
      system "tar", "-xf", "#{Formula["nginx"].opt_pkgshare}srcsrc.tar.xz", "--strip-components", "1"
    end
    system "tar", "-czf", buildpath"nginx.tar.gz", "nginx-#{Formula["nginx"].version}"

    system ".binpassenger-config", "compile-nginx-engine",
      "--nginx-tarball", buildpath"nginx.tar.gz",
      "--nginx-version", Formula["nginx"].version.to_s
    cp Dir["buildoutsupport-binariesnginx*"], libexec"buildoutsupport-binaries", preserve: true

    nginx_addon_dir.gsub!(^#{Regexp.escape Dir.pwd}, libexec)
    system ".devinstall_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec"bin", "#{nginx_addon_dir}config"

    man1.install Dir["man*.1"]
    man8.install Dir["man*.8"]
  end

  def caveats
    <<~EOS
      To activate Phusion Passenger for Nginx, run:
        brew install nginx
      And add the following to #{etc}nginxnginx.conf at the top scope (outside http{}):
        load_module #{opt_libexec}modulesngx_http_passenger_module.so;
      And add the following to #{etc}nginxnginx.conf in the http scope:
        passenger_root #{opt_libexec}srcruby_supportlibphusion_passengerlocations.ini;
        passenger_ruby usrbinruby;

      To activate Phusion Passenger for Apache, create etcapache2otherpassenger.conf:
        LoadModule passenger_module #{opt_libexec}buildoutapache2mod_passenger.so
        PassengerRoot #{opt_libexec}srcruby_supportlibphusion_passengerlocations.ini
        PassengerDefaultRuby usrbinruby
    EOS
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}binpassenger-config --ruby-libdir`.strip
    assert_equal "#{libexec}srcruby_supportlib", ruby_libdir

    (testpath"nginx.conf").write <<~EOS
      load_module #{opt_libexec}modulesngx_http_passenger_module.so;
      worker_processes 4;
      error_log #{testpath}error.log;
      pid #{testpath}nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        passenger_root #{opt_libexec}srcruby_supportlibphusion_passengerlocations.ini;
        passenger_ruby usrbinruby;
        client_body_temp_path #{testpath}client_body_temp;
        fastcgi_temp_path #{testpath}fastcgi_temp;
        proxy_temp_path #{testpath}proxy_temp;
        scgi_temp_path #{testpath}scgi_temp;
        uwsgi_temp_path #{testpath}uwsgi_temp;
        passenger_temp_path #{testpath}passenger_temp;

        server {
          passenger_enabled on;
          listen 8080;
          root #{testpath};
          access_log #{testpath}access.log;
          error_log #{testpath}error.log;
        }
      }
    EOS
    system "#{Formula["nginx"].opt_bin}nginx", "-t", "-c", testpath"nginx.conf"
  end
end