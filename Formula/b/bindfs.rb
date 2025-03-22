class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https:bindfs.org"
  url "https:bindfs.orgdownloadsbindfs-1.17.7.tar.gz"
  sha256 "c0b060e94c3a231a1d4aa0bcf266ff189981a4ef38e42fbe23296a7d81719b7a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:bindfs.orgdownloads"
    regex(href=.*?bindfs[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5f597072e6b0f0ba505c9754bf94530ae452f8d565acef90305ebcebaa0a7347"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "515aa180439b344708d23c95b2dfcd64b69c6cd9e3fb6a458e95a4469ebee204"
  end

  head do
    url "https:github.commpartelbindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    system bin"bindfs", "-V"
  end
end