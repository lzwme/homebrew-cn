class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://www.netdata.cloud/"
  url "https://ghfast.top/https://github.com/netdata/netdata/releases/download/v2.6.2/netdata-v2.6.2.tar.gz"
  sha256 "b56912a6bf0666c3f6304c60be547af69857431ad7596ff7de999178bf0ea0e2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "a4e8c8165e5ccad2eb3f1290aa1bb6a746896b19d09e017597de588e11d7e633"
    sha256 arm64_sonoma:  "5cd9b43417368727ee5d4922cf329af4d8b6cf5d9091173d93aefbed48b41c93"
    sha256 arm64_ventura: "06e7fe462b4fe027e6d2c19fdf44dd5cf71e132b14f80630ade445affff0a8d0"
    sha256 sonoma:        "05d89ddc3ea67e2a9a8ae2d18efd91759ba2b0b3df6ee2929ac2f1021f093050"
    sha256 ventura:       "523c440487daa71cd598516c48b257c211c3fab6bb3baa62f5a47bdcaebef20d"
    sha256 x86_64_linux:  "3a8ad82ae1bc4ae9ce5bef4cc9735f93e6c879468ec7b6d83eb963b93c5a5657"
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