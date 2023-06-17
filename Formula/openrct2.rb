class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.5",
      revision: "76ca8400cade0c6de5b47a7e44d405d56f278a83"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5e6e9c1e1f9a4a4acfc6e2387c13cc05b6ddbc0a03f3ba913380b0ccaf671c44"
    sha256 cellar: :any, arm64_monterey: "d5c1d2cbbfc2298ddf7a0e7ec220de5dd56754a2a5b8bbbe9d4248d2831c249d"
    sha256 cellar: :any, arm64_big_sur:  "983d716c2387fc3e880ec538c3692ac2e8ef620e23a94e0a6e08200eb05e85d2"
    sha256 cellar: :any, ventura:        "ded071b51b5f1d348bc54811ceb3e52c4119e8d10af91eb8f2d98feb247213e1"
    sha256 cellar: :any, monterey:       "1184d72083b432273a1971c920e26de61afe4dbb298815c2bcd33281da62e049"
    sha256 cellar: :any, big_sur:        "0b9497bb1ef582f6fe6482d83e604dc2a2f1a5f67e91715d0d2586869ff4dee5"
    sha256               x86_64_linux:   "f74ccde2fa7d945fe06511674c46588f05608b41fddf0173a5b5db57910e929a"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https://ghproxy.com/https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.0/title-sequences.zip"
    sha256 "6e7c7b554717072bfc7acb96fd0101dc8e7f0ea0ea316367a05c2e92950c9029"
  end

  resource "objects" do
    url "https://ghproxy.com/https://github.com/OpenRCT2/objects/releases/download/v1.3.8/objects.zip"
    sha256 "84a95590d13a753b1d239f7f06c8d121e36fd28694b21f33646518e2012904ae"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}",
                            "-DWITH_TESTS=OFF",
                            "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
                            "-DDOWNLOAD_OBJECTS=OFF",
                            "-DMACOS_USE_DEPENDENCIES=OFF",
                            "-DDISABLE_DISCORD_RPC=ON"
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end