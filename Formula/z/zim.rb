class Zim < Formula
  include Language::Python::Virtualenv

  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https:zim-wiki.org"
  url "https:github.comzim-desktop-wikizim-desktop-wikiarchiverefstags0.76.2.tar.gz"
  sha256 "02d201dd480762e8d6e503326861355ebd530b144b43bc6b7668526af620c77b"
  license "GPL-2.0-or-later"
  head "https:github.comzim-desktop-wikizim-desktop-wiki.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "068aa21ad1c7c64bcb3cb38e9d25e354f81400bf575ed0447c61eaa6ab129071"
  end

  depends_on "pkgconf" => :build
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
    url "https:files.pythonhosted.orgpackages32d27b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
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