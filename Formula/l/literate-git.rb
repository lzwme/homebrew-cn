class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https:github.combennorthliterate-git"
  url "https:files.pythonhosted.orgpackagesbd1dd8b406bb72174e3869c3d3242aec9ebd435a7b38cc9c4b0a34edd2bdf2b7literategit-0.4.7.tar.gz"
  sha256 "b669f7209638e1a2a98304f749f5f2cc594db353c2b50d7be720cf6b261da97e"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc3bb7409c8a14d06f16ca896b49b17c7549d217b8b809a5a13a5f99aae12ea1"
    sha256 cellar: :any,                 arm64_ventura:  "cb1aa2bd7f1dc350ff3e7bff5f47784725ee24cf1bcd20d829fdfb43b29a1183"
    sha256 cellar: :any,                 arm64_monterey: "daeff0fffe9d17ba3e4513faa7825d3b2a828fe66bdf537d130ab9faa30e62e1"
    sha256 cellar: :any,                 sonoma:         "f9190d897e5a7fe7e8abd0cc614925562db1eaa46c0aafa349669633546c8601"
    sha256 cellar: :any,                 ventura:        "56b6d56dee84f57f9030863a1566b1a3eac5912e540bd13e8c6db145a691e6df"
    sha256 cellar: :any,                 monterey:       "dbff94779ed3ffe9008b072f794854bc9da4f36ac47f88e43defc3524374711d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58fd27c6a6b014e312352d54e0972ec39c1f3b11f0eca601fe12fd0bccc618c9"
  end

  depends_on "libgit2@1.7"
  depends_on "python@3.12"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages7489a6bb59171d0bd5a3b19deb834ec29378a7c8e05bcb0a4dd4e5cb418ea03bmarkdown2-2.4.13.tar.gz"
    sha256 "18ceb56590da77f2c22382e55be48c15b3c8f0c71d6398def387275e6c347a9f"
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
    url "https:files.pythonhosted.orgpackagesf05e6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bfpygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
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
    (testpath"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end