class Zeek < Formula
  desc "Network security monitor"
  homepage "https:www.zeek.org"
  url "https:github.comzeekzeek.git",
      tag:      "v7.0.2",
      revision: "270429bfeacbcc21eabe1a73f26707e68d418abf"
  license "BSD-3-Clause"
  head "https:github.comzeekzeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "e9238f9f37be30fcfa92dc11ed7259d3ab1287b88e7e177fcf1802011a0d9a7b"
    sha256 arm64_sonoma:  "c8a307ef512be74896e10127dd59c7fa83da759e687316aaf157325fade2e39e"
    sha256 arm64_ventura: "8936cc5158c3ef75c98ff2ca44c717b76efd7a440792c3e8fc825a4ffc62ef13"
    sha256 sonoma:        "a22bff21c931d4ee13d7602ac2aff19069883fb6a8aab4e734849b01916d95fc"
    sha256 ventura:       "1c9a68e484f45d61c602f9aaf37f409a553e22c4d1a42a5d98de532012f75e93"
    sha256 x86_64_linux:  "178d0ba515a540139f8b8d8f253600ebb1532b0fe10be27063a224e8e63b72c2"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
                    "-DPYTHON_EXECUTABLE=#{which("python3.12")}",
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
    assert_predicate testpath"conn.log", :exist?
    refute_predicate testpath"conn.log", :empty?
    assert_predicate testpath"http.log", :exist?
    refute_predicate testpath"http.log", :empty?
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeekzeek#1468.
    refute_includes shell_output("#{bin}zeek-config --include_dir").chomp, "MacOSX"
  end
end