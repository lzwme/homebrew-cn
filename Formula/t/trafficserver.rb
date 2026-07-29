class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.1.4.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.4.tar.bz2"
    sha256 "47f09c65a3de70db38990124834f292081520e3290a7e781898291019b6f9d9f"

    depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  end

  # Allow livechecking for new releases while deprecated.
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_tahoe:   "7787222bc5925d56fa17ac3ab2a516ca51d9fb9a7db3d7d08047c558fa8c3735"
    sha256 arm64_sequoia: "9d25a72fbb101295e222ca3a428b0cead81a48cb93d4f5a993203793f0b1e451"
    sha256 arm64_sonoma:  "838592a775bc85242342a083096483a0c3f980ee3a896c5dd8ce7ce73b23c447"
    sha256 sonoma:        "d7382388698e26463ab9db47f84a30f2c1b3ea1e4477b005015e99a876689662"
    sha256 arm64_linux:   "8d4707adc332f73926b8c8e478e560fbcb501c0a5b87d326f9c8abec5954eeef"
    sha256 x86_64_linux:  "c235f6f3aed36c2ac590f460f8b4469711c468ea545fd5ce4bef2ec660aa34d4"
  end

  head do
    url "https://github.com/apache/trafficserver.git", branch: "master"

    depends_on "zstd"
  end

  # Can be undeprecated with 10.2.0 release.
  # Backporting PCRE2 support requires 30+ commits and resolving conflicts, so not worth it.
  deprecate! date: "2026-01-14", because: "needs EOL `pcre`"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "hwloc"
  depends_on "imagemagick"
  depends_on "libmaxminddb"
  depends_on "luajit"
  depends_on "nuraft"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    odie "Remove `pcre` dependency!" if build.stable? && version >= "10.2.0"

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXPERIMENTAL_PLUGINS=ON",
                    "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}",
                    "-DCMAKE_INSTALL_RUNSTATEDIR=#{var}/run/trafficserver",
                    "-DEXTERNAL_YAML_CPP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMAKE_INSTALL_SYSCONFDIR doesn't work as install_configs.cmake prepends the prefix
    configs = (prefix/"etc/trafficserver").children.select(&:file?)
    pkgetc.install configs
    (prefix/"etc/trafficserver").install_symlink configs.map { |config| pkgetc/config.basename }

    (var/"log/trafficserver").mkpath
    (var/"run/trafficserver").mkpath
    (var/"trafficserver").mkpath
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_server is not running", output
    end
  end
end