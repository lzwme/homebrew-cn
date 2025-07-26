class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://ghfast.top/https://github.com/netdata/netdata/releases/download/v2.6.1/netdata-v2.6.1.tar.gz"
  sha256 "663692f5671fa752e0240e519eca3683a777a7bd6ced880c8b573856b773b33b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "da3f561437a930b75b6785f853763ad9571fab6ea468979f74fa687a58fe8ff5"
    sha256 arm64_sonoma:  "ea733b4c1ab7f4dc458d26fa8a6d0e3ed56aac594909149309711385e7661a5e"
    sha256 arm64_ventura: "cc0c8afe8935afda50bf5058d4af08043c1af43e597d93bca28cf608d580dd58"
    sha256 sonoma:        "a6c4dfccae5c17c76c0f2476fc97ed6c22c850b543f738528f784774ad3de551"
    sha256 ventura:       "d74c9d4286e748149b09ea71c501f6a9b772903a7e2e8241b2aaa73230d91af5"
    sha256 x86_64_linux:  "8f4b18a2875a54930bc49ad023dbf6f8d88910265c2dc8a455aafd9605f83d4c"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
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

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_FOR_PACKAGING=ON",
                    "-DENABLE_PLUGIN_NFACCT=OFF",
                    "-DENABLE_PLUGIN_XENSTAT=OFF",
                    *std_cmake_args
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