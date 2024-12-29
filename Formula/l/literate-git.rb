class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https:github.combennorthliterate-git"
  url "https:files.pythonhosted.orgpackages7bcc1a6c994c90fa34cfa8e90e017c80f838b149fd0262daa24cdb930c091b48literategit-0.5.0.tar.gz"
  sha256 "88f9e95749d427c98a397a9c38a845d9760cf3451424441bc217c53c1ec835bd"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d2b025ddbab295193c1e6f827407d639a9d204c4e5f9cdb5f53fd9621d180c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796a2f7d9c28026fe53d797479b502dc6f32d2397334c924ea7f058ea857ecd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f014c600ce0139cd4e7ed823c48791e4589691ac5556eef4054b6e1e29ff84c"
    sha256 cellar: :any_skip_relocation, sonoma:        "74385ddd793439f8f9280f1e498e43678bc6b8430c3ff6a31607e89a8a45fa8c"
    sha256 cellar: :any_skip_relocation, ventura:       "4b9700e863cbe0fe8339cfa29c0b13ca998eb2bf7f763aca819cfcef2484e7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441c3d2a61e151bba2931e002e40c737fab41a491daa57174b09d8e821c1f56e"
  end

  depends_on "pygit2"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkgconf" => :build
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