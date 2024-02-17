class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https:github.comcontainerscrun"
  url "https:github.comcontainerscrunreleasesdownload1.14.2crun-1.14.2.tar.xz"
  sha256 "3b88754c366a97366480fc2b476be1c73f939afc184af79ace7e47b13f206e21"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08ca6f3cd849cce4bc95cb411815e33195a4069af4f8814f6589434f2217007e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system ".autogen.sh"
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}crun --rootless=true list -q").strip
  end
end