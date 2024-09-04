class GitRemoteHg < Formula
  include Language::Python::Shebang

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https:github.comfelipecgit-remote-hg"
  url "https:github.comfelipecgit-remote-hgarchiverefstagsv0.6.tar.gz"
  sha256 "1d49ffda290c8a307d32191655bdd85015e0e2f68bb2d64cddea04d8ae50a4bf"
  license "GPL-2.0-only"
  revision 2
  head "https:github.comfelipecgit-remote-hg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "62aaad29bee197840f65142bd9d7206a9c432dece29bf17197a4055fc4976295"
  end

  depends_on "asciidoctor" => :build
  depends_on "mercurial"
  depends_on "python@3.12"

  conflicts_with "git-cinnabar", because: "both install `git-remote-hg` binaries"

  def install
    rewrite_shebang detected_python_shebang, "git-remote-hg"
    system "make", "install", "prefix=#{prefix}"

    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"
    system "make", "install-doc", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https:www.mercurial-scm.orgrepohello"
  end
end