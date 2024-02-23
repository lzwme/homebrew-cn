class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https:github.comvasisquashfuse"
  url "https:github.comvasisquashfusearchiverefstagsv0.5.1.tar.gz"
  sha256 "c2cdaea87cc9b21536badf49d34ea691b508eb1825b2b628dbe5a7cca596b257"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6768c79eca48fe6c04131d597e36dcfcf527715ee22e9594ef86488dd405f41e"
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
    system ".autogen.sh"
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Unfortunately, makingtesting a squash mount requires sudo privileges, so
    # just test that squashfuse execs for now.
    output = shell_output("#{bin}squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end