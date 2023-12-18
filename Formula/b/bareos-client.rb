class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https:www.bareos.org"
  url "https:github.combareosbareosarchiverefstagsRelease23.0.0.tar.gz"
  sha256 "6d3afe2a6e3340e2942f654546a1e919242511dede783aff1c8a97a81bc6a706"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sonoma:   "67a97a926bf3dc80d3f865394bbfa8b1dda02c2e757982744daa9ad1767a2e1a"
    sha256 arm64_ventura:  "cd0ea4ea5bc7832b023f991febe2b0441e3be401b802bb47a3e28c0c1efb6cf7"
    sha256 arm64_monterey: "e9f27d70e50b34e3ffce8c90e350a49e7046c8ccaf86d169278908047af592bf"
    sha256 sonoma:         "34ec8d8d7344d3e1307ddfba28a382a961459e36103da5aad3cc133f80dc8d14"
    sha256 ventura:        "66889f9f5350750f8127b6991f44aca5509378e51b4b6ea8bfab69c5a567d3bf"
    sha256 monterey:       "b4744d44b8c7a229e6bae7a57bf39b823b65dfe0dced9bcb7c9e76190fef184a"
    sha256 x86_64_linux:   "451cdf9dac8e6d3a1d392244b340c1a69b377d122ba3fd4f8b12080beab94f96"
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

  # build patch for `sprintf` error, upstream PR ref, https:github.combareosbareospull1636
  patch do
    url "https:github.combareosbareoscommitbac6e7f30c0ef0df859e62bd1cd47ed563175d2a.patch?full_index=1"
    sha256 "1768352769ee7e5f54831d402e8458ddc13c02bfe18a6d96003b45c64dc8b965"
  end

  def install
    # Work around Linux build failure by disabling warnings:
    # lmdbmdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # fastlzlib.c:512:63: error: unused parameter ‘output_length’ [-Werror=unused-parameter]
    # Upstream issue: https:bugs.bareos.orgview.php?id=1504
    if OS.linux?
      ENV.append_to_cflags "-Wno-unused-but-set-variable"
      ENV.append_to_cflags "-Wno-unused-parameter"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_PYTHON=OFF",
                    "-Dworkingdir=#{var}libbareos",
                    "-Darchivedir=#{var}bareos",
                    "-Dconfdir=#{etc}bareos",
                    "-Dconfigtemplatedir=#{lib}bareosdefaultconfigs",
                    "-Dscriptdir=#{lib}bareosscripts",
                    "-Dplugindir=#{lib}bareosplugins",
                    "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                    "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                    "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dclient-only=ON",
                    "-DENABLE_LZO=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var"libbareos").mkpath
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc"bareosbareos-fd.d").exist?
      system lib"bareosscriptsbareos-config", "deploy_config",
             lib"bareosdefaultconfigs", etc"bareos", "bareos-fd"
      system lib"bareosscriptsbareos-config", "deploy_config",
             lib"bareosdefaultconfigs", etc"bareos", "bconsole"
    end
  end

  service do
    run [opt_sbin"bareos-fd", "-f"]
    require_root true
    log_path var"runbareos-fd.log"
    error_log_path var"runbareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}bareos-fd -? 2>&1")
    # Check if the configuration is valid.
    system sbin"bareos-fd", "-t"
  end
end