class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://ghproxy.com/https://github.com/bareos/bareos/archive/refs/tags/Release/22.1.1.tar.gz"
  sha256 "6fb0b57a7bfc8fb68c678003b5a8cc7b95f5d3f3b55d837219af183999fab451"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sonoma:   "90e24e71f6e5001ec088f9ae3b3d76dcadd9f6d0cfc43bf29df69dc760aa092e"
    sha256 arm64_ventura:  "e67e3026fba9a1754bf3083c4c3ce33a3aad8b42360b5dbcc9b8d3834f38f031"
    sha256 arm64_monterey: "af94f17f91de8e2f4f084bd23baecbe7c10b5e4079d55f7247ebd7ac3774b5e3"
    sha256 sonoma:         "e4aa2474c0a4f8f903e5655bd4bd17f9c62e4c885ed4086223843e6450e5b7bb"
    sha256 ventura:        "0e92f8657163700624e253126f10931f21264520fc838dfa5857d5a3dfc55b9b"
    sha256 monterey:       "a136e88d223636f04d604acbb3d273aeee91f4c34284f23c7aa69a18f6d133ef"
    sha256 x86_64_linux:   "42b9c2bf70ceccbf29fa89990b2edc0f16f350a29e67e30bb8d9c4e8c0a4bdfe"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "bacula-fd", because: "both install a `bconsole` executable"

  def install
    # Work around Linux build failure by disabling warnings:
    # lmdb/mdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # fastlzlib.c:512:63: error: unused parameter ‘output_length’ [-Werror=unused-parameter]
    # Upstream issue: https://bugs.bareos.org/view.php?id=1504
    if OS.linux?
      ENV.append_to_cflags "-Wno-unused-but-set-variable"
      ENV.append_to_cflags "-Wno-unused-parameter"
    end

    # Work around hardcoded paths to /usr/local Homebrew installation,
    # forced static linkage on macOS, and openssl formula alias usage.
    inreplace "core/CMakeLists.txt" do |s|
      s.gsub! "/usr/local/opt/gettext/lib/libintl.a", Formula["gettext"].opt_lib/shared_library("libintl")
      s.gsub! "/usr/local/opt/openssl", Formula["openssl@3"].opt_prefix
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end
    inreplace "core/src/plugins/CMakeLists.txt" do |s|
      s.gsub! "/usr/local/opt/gettext/include", Formula["gettext"].opt_include
      s.gsub! "/usr/local/opt/openssl/include", Formula["openssl@3"].opt_include
    end
    inreplace "core/cmake/BareosFindAllLibraries.cmake" do |s|
      s.gsub! "/usr/local/opt/lzo/lib/liblzo2.a", Formula["lzo"].opt_lib/shared_library("liblzo2")
      s.gsub! "set(OPENSSL_USE_STATIC_LIBS 1)", ""
    end
    inreplace "core/cmake/FindReadline.cmake",
              "/usr/local/opt/readline/lib/libreadline.a",
              Formula["readline"].opt_lib/shared_library("libreadline")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_PYTHON=OFF",
                    "-Dworkingdir=#{var}/lib/bareos",
                    "-Darchivedir=#{var}/bareos",
                    "-Dconfdir=#{etc}/bareos",
                    "-Dconfigtemplatedir=#{lib}/bareos/defaultconfigs",
                    "-Dscriptdir=#{lib}/bareos/scripts",
                    "-Dplugindir=#{lib}/bareos/plugins",
                    "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                    "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                    "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dclient-only=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/bareos").mkpath
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc/"bareos/bareos-fd.d").exist?
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bareos-fd"
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bconsole"
    end
  end

  service do
    run [opt_sbin/"bareos-fd", "-f"]
    require_root true
    log_path var/"run/bareos-fd.log"
    error_log_path var/"run/bareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1")
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end