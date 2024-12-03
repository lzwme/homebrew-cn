class Zeek < Formula
  desc "Network security monitor"
  homepage "https:zeek.org"
  url "https:github.comzeekzeekreleasesdownloadv7.0.4zeek-7.0.4.tar.gz"
  sha256 "131050fee95fd76400322cc9e80db6d797e296361d43e3fb10f3ceb1bf93428e"
  license "BSD-3-Clause"
  head "https:github.comzeekzeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "12b1cd7e3ec2569e5d672b2d9f5b962591c966e9ca5cb1b79ea839e691fe8827"
    sha256 arm64_sonoma:  "42da09f6b116751971e9242ba9e0acb63ecf24df7f341473b3c017323e93a63f"
    sha256 arm64_ventura: "60f3432301a65922857b7a7604f0fc7fdac5a798ba80d41de3300e67306f1485"
    sha256 sonoma:        "fe895bcfab62b6986a90519cd181fa2263784374fb3e957f6caefa032a21f600"
    sha256 ventura:       "ee6d60214e21ef0ff49de62bfcc6021ee0eb791897931f1401fe483d08d4ef44"
    sha256 x86_64_linux:  "5c3c8e13bbf55c0478b5afab3ddcb3bdd0b70250765897b22598b7aa4873feb1"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https:github.comHomebrewhomebrew-corepull74932
    inreplace "cmake_templateszeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxilspicyhiltitoolchainsrcconfig.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_libshared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_libshared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.13")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}zeek --version")
    assert_match "ARP packet analyzer", shell_output("#{bin}zeek --print-plugins")
    system bin"zeek", "-C", "-r", test_fixtures("test.pcap")
    assert_path_exists testpath"conn.log"
    refute_empty (testpath"conn.log").read
    assert_path_exists testpath"http.log"
    refute_empty (testpath"http.log").read
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeekzeek#1468.
    refute_includes shell_output("#{bin}zeek-config --include_dir").chomp, "MacOSX"
  end
end