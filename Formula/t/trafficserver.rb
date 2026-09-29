class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.2.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.2.0.tar.bz2"
  sha256 "bef171a7d064794e05ec7559e46d3e07c3ae6487a4647987fcc4f1cc5a82cec6"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/trafficserver.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "25dc171995cf3f45663d95c1953575322ef2267059f50e70dd1a5ee0771d7217"
    sha256 arm64_tahoe:       "695ab27752e888384b39aba46f8e240306c673b645cbda0310ca900c65b3f6cd"
    sha256 arm64_sequoia:     "fdc674281e20e886b735130ec9f77ec4ef1e71c2a07734d488304d38dad243d0"
    sha256 arm64_linux:       "0e136daa8aeb1d44194875dfae62bf16de73403a24b47792d0e1ea16c117706c"
    sha256 x86_64_linux:      "fdd1a3704ed6e98176eee285f43a772685faabac9657f7fe43021a0dd19db5b2"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "hwloc"
  depends_on "imagemagick"
  depends_on "libmaxminddb"
  depends_on "luajit"
  depends_on "nuraft"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
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