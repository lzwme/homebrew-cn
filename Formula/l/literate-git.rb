class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https:github.combennorthliterate-git"
  url "https:files.pythonhosted.orgpackages7bcc1a6c994c90fa34cfa8e90e017c80f838b149fd0262daa24cdb930c091b48literategit-0.5.0.tar.gz"
  sha256 "88f9e95749d427c98a397a9c38a845d9760cf3451424441bc217c53c1ec835bd"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9235220e16c529400db78d67cc49139ae568afd127f8ed72365a331a45a3dd5"
    sha256 cellar: :any,                 arm64_sonoma:  "4747522269d62bca08a9ea83c7d82d5e44ad619170e7de9c640c8be7da771e90"
    sha256 cellar: :any,                 arm64_ventura: "529c137577be7605754a22ef3b958ace7bf7bb05a8e63bfbad9dc1466064a3fe"
    sha256 cellar: :any,                 sonoma:        "40909dbcead9b8c6bc8290afd4c2d6ed8e468f4af60e391425b90f1c37000ea0"
    sha256 cellar: :any,                 ventura:       "3859333485640c20f338dda8d673ffe0acb17de24fd52820ee0b0536f4cbb949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2b8b137ffbfc8992052e3c5d0ebe578a402c367278601d1958f5577768c12c"
  end

  depends_on "libgit2"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkgconf" => :build
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackagesfc97c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90dcffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackagesa061d3c0c21280ba1fc348822a4410847cf78f99bba8625755a5062a44d2e228markdown2-2.5.2.tar.gz"
    sha256 "3ac02226a901c4b2f6fc21dbd17c26d118d2c25bcbb28cee093a1f8b5c46f3f1"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackagesa485c848cdf44214bf541c4a725a0a6e271f8db9f18cfccef702d53f83f1e19apygit2-1.16.0.tar.gz"
    sha256 "7b29a6796baa15fc89d443ac8d51775411d9b1e5b06dc40d458c56c8576b48a2"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath"create_url.py").write <<~PYTHON
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    PYTHON
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end