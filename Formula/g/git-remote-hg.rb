class GitRemoteHg < Formula
  include Language::Python::Shebang

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https:github.comfelipecgit-remote-hg"
  url "https:github.comfelipecgit-remote-hgarchiverefstagsv0.6.tar.gz"
  sha256 "1d49ffda290c8a307d32191655bdd85015e0e2f68bb2d64cddea04d8ae50a4bf"
  license "GPL-2.0"
  revision 2
  head "https:github.comfelipecgit-remote-hg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99779563fc8ad0f066f1531ec560061311e53479eeba3a79f920ba0675bf0a9e"
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