class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://ghfast.top/https://github.com/zeek/zeek/releases/download/v9.0.0/zeek-9.0.0.tar.gz"
  sha256 "1345474b3ea04c700f5421c30c7b81cf570056a16842abba03dfa5e2b6e3ed4e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e5557054d7fc5c09d832ac778e4d7dedc99980189929ac0147faf01a60adcc1e"
    sha256 arm64_tahoe:       "8b27db4adceaa47f0c20d3a80014fbd29325c5132a2661a7c206cdc5bf750be1"
    sha256 arm64_sequoia:     "458dd2eacad5d49d57115832c972718a95b20bd61c73fe3f284cb6bc5f4ef1b4"
    sha256 arm64_linux:       "8671fcfe5f1299076536aef45ecf8124db777b80ab14720697b5ade12e44cef0"
    sha256 x86_64_linux:      "79f7d35ee5ad907c291c308246a30d8ffdaf75eb4dbef9a4f9ec46a1a5d0ba5e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "libuv"
  depends_on "node@24"
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "cmake_templates/zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    args = %W[
      -DBROKER_DISABLE_TESTS=on
      -DINSTALL_AUX_TOOLS=on
      -DINSTALL_ZEEKCTL=on
      -DUSE_GEOIP=on
      -DCARES_ROOT_DIR=#{formula_opt_prefix("c-ares")}
      -DCARES_LIBRARIES=#{formula_opt_lib("c-ares")/shared_library("libcares")}
      -DLibMMDB_LIBRARY=#{formula_opt_lib("libmaxminddb")/shared_library("libmaxminddb")}
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DPYTHON_EXECUTABLE=#{python3}
      -DZEEK_ETC_INSTALL_DIR=#{etc}
      -DZEEK_LOCAL_STATE_DIR=#{var}
      -DDISABLE_JAVASCRIPT=off
      -DNODEJS_ROOT_DIR=#{formula_opt_prefix("node@24")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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