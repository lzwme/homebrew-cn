class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://ghfast.top/https://github.com/radareorg/sdb/archive/refs/tags/2.2.8.tar.gz"
  sha256 "82f6c5f640c2c41a965f72293c62afd364cd1ffcfd61a8016e6e43f33ce3dcf9"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "474b6542ce8c972d23a27bf0392fd0e8ff54e5435f7b12d42a2615846b665ecc"
    sha256 cellar: :any,                 arm64_sequoia: "f5d2dca05b7d18dcee366b150e8433c33458684b2ac7c45477f743579e7df677"
    sha256 cellar: :any,                 arm64_sonoma:  "d10c97becf835b4a4c294775ba492f30ec652289fa4aae3ee6d9caf42c3e1b98"
    sha256 cellar: :any,                 sonoma:        "5539f8df0c9bb76042ba2abd3515d0dd205b6f0166a7b762336ef9073a1ced9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c53679eb94320aa41e01f135abee335a4b492a126cda147035cf136f986429e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9983bbd87ff575a12d6b2d2a94edfa277235e8c4dfb1f26b369b3a37279c2113"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end