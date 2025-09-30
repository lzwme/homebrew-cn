class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://ghfast.top/https://github.com/netdata/netdata/releases/download/v2.7.1/netdata-v2.7.1.tar.gz"
  sha256 "8ee20481472f1ceeb40f181a3699897dae5785afbd13d88d3e15d8e7f98f5e44"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "217d174723b4cd5a29dbcc4c5c48d5c1d1e636fb7e471804599cbb915333ee98"
    sha256 arm64_sequoia: "9cb201e12b076bba2fcc411b6f3be01724123c5201c6b6886dcdf021a3d15591"
    sha256 arm64_sonoma:  "9e96f037bbab593e4da6aaf9efc89dc376eb1c1050f1c66639a9931a05cda4e8"
    sha256 sonoma:        "af6f9fdbb9cc78f026f52ac5cb9a105eab4d328f2ff6255a3f64b927cd2cd4d7"
    sha256 x86_64_linux:  "706a70e30cd25b07520f67a6457bd391a7777dc7ad014094431a7f27ae08141e"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "abseil"
  depends_on "dlib"
  depends_on "json-c"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "brotli"
    depends_on "elfutils"
    depends_on "freeipmi"
    depends_on "libcap"
    depends_on "libmnl"
    depends_on "systemd"
    depends_on "util-linux"
    depends_on "zstd"
  end

  def install
    # Fix to error: no member named 'tcps_sc_zonefail' in 'struct tcpstat'
    # Issue ref: https://github.com/netdata/netdata/issues/20985
    if OS.mac? && MacOS.version >= :tahoe
      inreplace "src/collectors/macos.plugin/macos_sysctl.c",
                'rrddim_set(st, "SyncookiesFailed", tcpstat.tcps_sc_zonefail);',
                ""
    end

    # Install files using Homebrew's directory layout rather than relative to root.
    inreplace "packaging/cmake/Modules/NetdataEBPFLegacy.cmake", "DESTINATION usr/", "DESTINATION "
    inreplace "CMakeLists.txt" do |s|
      s.gsub! %r{(\s"?(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?)usr/}, "\\1"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?etc/}, "\\1#{etc}/"
      s.gsub! %r{(\s"?)(?:\$\{NETDATA_RUNTIME_PREFIX\}/)?var/}, "\\1#{var}/"
      # Fix not to use `fetchContent` for `dlib` library
      # Issue ref: https://github.com/netdata/netdata/issues/20147
      s.gsub! "netdata_bundle_dlib()", "find_package(dlib REQUIRED)"
      s.gsub! "netdata_add_dlib_to_target(netdata)", ""
    end

    args = %w[
      -DBUILD_FOR_PACKAGING=ON
      -DENABLE_PLUGIN_NFACCT=OFF
      -DENABLE_PLUGIN_XENSTAT=OFF
    ]
    # Avoid to use FetchContent for `corrosion`
    args += %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"cache/netdata/unittest-dbengine/dbengine").mkpath
    (var/"lib/netdata/registry").mkpath
    (var/"lib/netdata/lock").mkpath
    (var/"log/netdata").mkpath
    (var/"netdata").mkpath
  end

  service do
    run [opt_sbin/"netdata", "-D"]
    working_dir var
  end

  test do
    directories = prefix.children(false).map(&:to_s)
    %w[usr var etc].each { |dir| refute_includes directories, dir }

    system sbin/"netdata", "-W", "set", "registry", "netdata unique id file",
                           "#{testpath}/netdata.unittest.unique.id",
                           "-W", "set", "registry", "netdata management api key file",
                           "#{testpath}/netdata.api.key"
  end
end