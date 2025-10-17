class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://ghfast.top/https://github.com/netdata/netdata/releases/download/v2.7.2/netdata-v2.7.2.tar.gz"
  sha256 "7f0ab7d3bc91cc23df305b07c7e2ea5d593db4547e00bd28674858b467e52ed7"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "369302f8d44766b8ffd69a484c044f70b52a0607f1db9e2223f48559e7ddd05a"
    sha256 arm64_sequoia: "19d7dc00f58fe2d7e1c963124ba8416a081bf8609dea38ed66e5e3af170e0bdf"
    sha256 arm64_sonoma:  "43aee017685c560710722320498ab597da0d0b9033dd5697fbf6041b1132ecad"
    sha256 sonoma:        "0fd26b9bc5fc366a3be0ff08f7d678c995df7ebb5e8ab4568e4a74a68c8254ba"
    sha256 x86_64_linux:  "63cd1254a3c88042f1337e67e1fd16de3a89404fdf415a77e3b6b3cc010d7bde"
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