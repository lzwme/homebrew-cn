class Chunkah < Formula
  desc "OCI building tool for content-based layers"
  homepage "https://github.com/coreos/chunkah"
  url "https://ghfast.top/https://github.com/coreos/chunkah/releases/download/v0.6.0/chunkah-0.6.0.tar.gz"
  sha256 "de9c4905225cc30270c734c7aa6f27b870e188fb38013f35a144250008a1c90d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "fcfa4a846a77542a308238aff164be13ea81f8ed02edf6522b700df778882de3"
    sha256 cellar: :any, x86_64_linux: "3fe148a0a8c74780947f906bf8e48933f8a4c4a625f930ec560736a417899f95"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "openssl@4"
  depends_on "zlib-ng-compat"

  resource "homebrew-test-rootfs" do
    url "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.4-x86_64.tar.gz"
    sha256 "85498865362aa7ebececa0d725a2f2e4db7ac4e4b2850b8df21645afa0d03ee3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource("homebrew-test-rootfs").stage "rootfs"
    system bin/"chunkah", "build", "--rootfs", "rootfs", "--output", "output.tar"
    assert_path_exists testpath/"output.tar"
  end
end