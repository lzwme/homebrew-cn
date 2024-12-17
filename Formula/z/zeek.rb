class Zeek < Formula
  desc "Network security monitor"
  homepage "https:zeek.org"
  url "https:github.comzeekzeekreleasesdownloadv7.0.5zeek-7.0.5.tar.gz"
  sha256 "e0e6e6f5d5b0402bb1ccd02ecee0ac5bd237d60c5095d71a146651c7f6721eb7"
  license "BSD-3-Clause"
  head "https:github.comzeekzeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "b59d9300cf46a05790666a0d26ec6e26e58bf413faf45e80752b3182ab6115e9"
    sha256 arm64_sonoma:  "b551c13b0285208dd0c92cb518962ca90c5e7d4bc7cd2a0588ac85a54e15480f"
    sha256 arm64_ventura: "536acf226a4aac68b35d09a782abae0262671c5d27f4348a6a3386537a3adc92"
    sha256 sonoma:        "f52ea9b8771467304efd1798df99a01aad17d90a9af00c77705ab242a3ecaee1"
    sha256 ventura:       "3c3dec15dd23c41881409b4666146a15d5d5ca922f3c5d6bd7112a597fe1eff3"
    sha256 x86_64_linux:  "659bb68e3c0ab031412e32dffdbea315fc2fdd6eb28a9b9cff657a7552f60bd2"
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