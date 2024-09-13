class Zeek < Formula
  desc "Network security monitor"
  homepage "https:www.zeek.org"
  url "https:github.comzeekzeek.git",
      tag:      "v7.0.1",
      revision: "3bf8bfaac6784105d0c3cbbc18cf1d27952da81f"
  license "BSD-3-Clause"
  head "https:github.comzeekzeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "ab9ce42301f74319053bd8d80e5b8f5ee283478feeba01513d210382836bc004"
    sha256 arm64_sonoma:   "1807de1c81ebd99fe8e17c411749aa8ebf72d3c8bc944bb4bff07215c79121f7"
    sha256 arm64_ventura:  "fc94b9a0b216e9e36b668eee160a0ab19d267c53cdfdd8e65cd06b3d9fbfe551"
    sha256 arm64_monterey: "fd11db326585c93393ca80a60d4c05d1a7552638ac3b09177fe322c6b79aeb45"
    sha256 sonoma:         "341adc40d8bd1a5bc0f29f46e17d99c93b72a95721f918f4fb0016245f51a193"
    sha256 ventura:        "988145faf592a7cad81170443c5d0577b617bcf03e2093fb280315215e995612"
    sha256 monterey:       "d917ffbda1f02c30439c524281f7c8454d02585d32b9295c301f5d4f0b24c614"
    sha256 x86_64_linux:   "ff5c95a832385a6dac24809e8d17fe978c2634b34cb3f4bfbedcad01d36a0529"
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