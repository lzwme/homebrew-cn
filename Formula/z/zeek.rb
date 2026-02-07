class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://ghfast.top/https://github.com/zeek/zeek/releases/download/v8.1.1/zeek-8.1.1.tar.gz"
  sha256 "b5f9edd4a10412426e6414d2f851ba42ce1fa94b59ccbad4238519adae6fc065"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "20445c8a927c7800ebb1018f8bb8d35eba01dae0a64e67bbe817e3b499dcbee9"
    sha256 arm64_sequoia: "483bc41603ebbf4eddd090954a0ad02941a022eb4db8e6196d274962e99c6c6b"
    sha256 arm64_sonoma:  "15b8426a1e7f6cdfb7d0a8c8be1cd220f579d4a2a13b9f1f62841c78cee9bf34"
    sha256 sonoma:        "503f98cf7e8f4b9908b358bfa7b4efb0b83c687d560fe76026d3f92e31e6a8b1"
    sha256 arm64_linux:   "47068489ef73b07cbc7a5a4fc2a59ab9e093045fb4daa5188b98c5bbb73d803f"
    sha256 x86_64_linux:  "20fcadcb2d359d4ab19ce99850a6052c3f6a59a57507df4b987f303e0894cb6c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "cmake_templates/zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_lib/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_lib/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.14")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP packet analyzer", shell_output("#{bin}/zeek --print-plugins")
    system bin/"zeek", "-C", "-r", test_fixtures("test.pcap")
    assert_path_exists testpath/"conn.log"
    refute_empty (testpath/"conn.log").read
    assert_path_exists testpath/"http.log"
    refute_empty (testpath/"http.log").read
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeek/zeek#1468.
    refute_includes shell_output("#{bin}/zeek-config --include_dir").chomp, "MacOSX"
  end
end