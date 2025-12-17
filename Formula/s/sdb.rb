class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://ghfast.top/https://github.com/radareorg/sdb/archive/refs/tags/2.2.6.tar.gz"
  sha256 "622c5ed9c6e84d28f6b9800a76c22c6ca88289dd1837cb6e84b46e59a79dc585"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99c0148b445148ba297a56b69c997b4392fd3a427384d650a9cee00924897120"
    sha256 cellar: :any,                 arm64_sequoia: "3bafd740737ba414a7afff3737597495b2f0eb183a62fc9ca0de8c78eb8f96c6"
    sha256 cellar: :any,                 arm64_sonoma:  "5988325447e4de4b57744d93ca7a7ec60fad46bee62887e7c1552cdac293c754"
    sha256 cellar: :any,                 sonoma:        "22897691d44d0be4974a1043a4da25ca1d36468fdc3009e415757d88409ede77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f280c1c725a980d966481f3a07e6c64a06dbaa3e3eec5809b23bc7e4c356ee8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81599694709832ada26c5d4ddca36452b35a5000bb91af7c682b7eca32205382"
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