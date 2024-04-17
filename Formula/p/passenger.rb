class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via ApacheNGINX"
  homepage "https:www.phusionpassenger.com"
  url "https:github.comphusionpassengerreleasesdownloadrelease-6.0.20passenger-6.0.20.tar.gz"
  sha256 "fa8d9a37edb92f4a8f064b3005b57bccf10392ce4eb067838883206060e27107"
  license "MIT"
  revision 2
  head "https:github.comphusionpassenger.git", branch: "stable-6.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4b88a28a56560f80b0ac9c18e3d3a4ff14cc35f48bd0a0bc0e2e3fb66e2716db"
    sha256 cellar: :any,                 arm64_ventura:  "a5b8a58de35cfd04146d08b65ef5ee2d14c4171c8e3f1605d61a163e85a9e160"
    sha256 cellar: :any,                 arm64_monterey: "2e39a291cc1b45819ed0565e8501da3a23edc7823c17b987eabcfeef85211012"
    sha256 cellar: :any,                 sonoma:         "24c4d8a8538a5bfb06ead8c23485d8250ae0dcd70e4a40e89f3edb7a632c5736"
    sha256 cellar: :any,                 ventura:        "befb42fe60003378b621314ffa150954fc5d22f1e05e4c8b6319b99a887d26a9"
    sha256 cellar: :any,                 monterey:       "cba29c6c5df8b92c96f1dfbffca5a2a3ec8ac0ff9668a517db10fa67bc7247d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e91c5eb40e145fd3938a7951b100c6b3d6119a96b485322478f74437f509a6"
  end

  depends_on "httpd" => :build # to build the apache2 module
  depends_on "nginx" => [:build, :test] # to build nginx module
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby", since: :catalina

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
    rm_rf "buildoutlibev"
    rm_rf "buildoutlibuv"
    rm_rf "buildoutcache"

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

    # See https:github.comHomebrewhomebrew-corepull84379#issuecomment-910179525
    deuniversalize_machos
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