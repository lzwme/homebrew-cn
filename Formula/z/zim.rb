class Zim < Formula
  include Language::Python::Virtualenv

  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https:zim-wiki.org"
  url "https:github.comzim-desktop-wikizim-desktop-wikiarchiverefstags0.75.2.tar.gz"
  sha256 "79d20946d2c51fb1285b8a80b8afedb39402d6e4f1349ebe4be945318f275493"
  license "GPL-2.0-or-later"
  head "https:github.comzim-desktop-wikizim-desktop-wiki.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "f4824f56d36bfe7a27b6e5ca299247eb1e1a85416c112506303164ce6ac9f28f"
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "pyxdg" do
    url "https:files.pythonhosted.orgpackagesb0257998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  def python3
    "python3.13"
  end

  def install
    build_venv = virtualenv_create(buildpath"venv", python3)
    build_venv.pip_install resource("setuptools")
    ENV.prepend_create_path "PYTHONPATH", build_venv.site_packages

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install buildpath, build_isolation: false
    (bin"zim").write_env_script libexec"binzim",
                                 XDG_DATA_DIRS: [HOMEBREW_PREFIX"share", libexec"share"].join(":")
    share.install (libexec"share").children
    pkgshare.install "zim"

    # Make the bottles uniform
    inreplace [
      venv.site_packages"zimconfigbasedirs.py",
      venv.site_packages"xdgBaseDirectory.py",
      pkgshare"zimconfigbasedirs.py",
    ], "usrlocal", HOMEBREW_PREFIX
  end

  test do
    # Workaround for https:github.comzim-desktop-wikizim-desktop-wikiissues2665
    ENV["LC_ALL"] = (OS.mac? && MacOS.version >= :sequoia) ? "C" : "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    mkdir_p %w[NotesHomebrew HTML]
    # Equivalent of (except doesn't require user interaction):
    # zim --plugin quicknote --notebook .Notes --page Homebrew --basename Homebrew
    #     --text "[[https:brew.sh|Homebrew]]"
    File.write(
      "NotesHomebrewHomebrew.txt",
      "Content-Type: textx-zim-wiki\nWiki-Format: zim 0.4\n" \
      "Creation-Date: 2020-03-02T07:17:51+02:00\n\n[[https:brew.sh|Homebrew]]",
    )
    system bin"zim", "--index", ".Notes"
    system bin"zim", "--export", "-r", "-o", "HTML", ".Notes"
    assert_match "Homebrew:Homebrew", (testpath"HTMLHomebrewHomebrew.html").read
    assert_match "https:brew.sh|Homebrew", (testpath"NotesHomebrewHomebrew.txt").read
  end
end