class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://ghfast.top/https://github.com/radareorg/sdb/archive/refs/tags/2.3.0.tar.gz"
  sha256 "4d569fe008b8088b5067419b2b54032a6e6f31c73cd5c4ef20c1ca2602c80da9"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "852f9674295f7582c741c116fb35dfd2ace82385f1154de46f327667b386c0cd"
    sha256 cellar: :any,                 arm64_sequoia: "f6c71661c8d821b299fadc1eda1e71c4b6780470006c26251c1fb5d54067d427"
    sha256 cellar: :any,                 arm64_sonoma:  "fb33649aa07f86e7f414dba560a7b954002e762b2875622c8d212371539153c5"
    sha256 cellar: :any,                 sonoma:        "f48f5b459b2431684b942ea6f3c9ac274722e7250f1d79395313c0047fc91737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c2c7044aadc97d48ae1295099929ceb0217af0e35677f09b47915ed22e1c866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0a84b5d22ad2c85195c8fa3e7e2676ece74000b9fbf3c33116eb6efcc2fa20"
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