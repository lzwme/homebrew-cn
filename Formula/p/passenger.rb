class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via ApacheNGINX"
  homepage "https:www.phusionpassenger.com"
  url "https:github.comphusionpassengerreleasesdownloadrelease-6.0.21passenger-6.0.21.tar.gz"
  sha256 "c4a283256c0e24c684fa685729c564a203df49391890ce32c25895644f63d920"
  license "MIT"
  head "https:github.comphusionpassenger.git", branch: "stable-6.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a100773fcee70dcf18d289010fd2e837f8f03a25284918dda2b74e9f657c19c4"
    sha256 cellar: :any,                 arm64_ventura:  "3bcf3e07dddaa44033a31534e0b73077df389e398d57c2ef4deb4ab1202b9f46"
    sha256 cellar: :any,                 arm64_monterey: "d00c168c641de08637c7401ea978a65cf3c7f137b24d1238250e8b0b6082a99b"
    sha256 cellar: :any,                 sonoma:         "1f7307b4d6d84c0925a233c517a2c4f14e3b76a02189185cd7cb9dc5204f30bc"
    sha256 cellar: :any,                 ventura:        "a765981e73ed6580810ba2d770f851a368aa2f453faf282b9cd6a70b5a7e2532"
    sha256 cellar: :any,                 monterey:       "8949ae5c364881a34c6ba0ba68b47d553dfe698ad06a667187335de224d133bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a248e188b1df6e05e156704962bc207a0e16af3523d95377e4d22ef4b57d79e"
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