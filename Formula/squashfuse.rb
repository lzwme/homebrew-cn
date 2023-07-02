class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://ghproxy.com/https://github.com/vasi/squashfuse/archive/refs/tags/0.2.0.tar.gz"
  sha256 "5f088257e877cd8f5fc1232801b4d412b44a017054953acc11bc16a58462b1b0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe4d5df512c0246d5b14e3e22dbecda2d4749c2a0ccdb0c681cdf5f1b933d3b4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "lz4"
  depends_on "lzo"
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zstd"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Unfortunately, making/testing a squash mount requires sudo privileges, so
    # just test that squashfuse execs for now.
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end