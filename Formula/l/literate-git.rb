class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/0e/e37f96177ca5227416bbf06e96d23077214fbb3968b02fe2a36c835bf49e/literategit-0.5.1.tar.gz"
  sha256 "3db9099c9618afd398444562738ef3142ef3295d1f6ce56251ba8d22385afe44"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53e9e9035b79074fdd76c70c10b4c03e663f4aeebd5de06c2a4006d54bc2197d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e9fc35621839feeb70793e62453fcaa349b080b2ca0ef71ff7e47f8d6aa14f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1deccec18bfdd5c3a11958fb12ed93c9bb69a46391dd3ea45dac7923a8791850"
    sha256 cellar: :any_skip_relocation, sonoma:        "52e1b30262f847803440d3caeaf6043885ac63094ef46175a326c4e8ca8e67ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae8b4772ead1e786684aac2ac5f6d14118064f8baf823dbea4b0d3ba9523dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d52288f087de750af0f59b7f241047dd2855b2930df13a22d3b7bf970b54663"
  end

  depends_on "pkgconf" => :build
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pygit2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e4/ae/07d4a5fcaa5509221287d289323d75ac8eda5a5a4ac9de2accf7bbcc2b88/markdown2-2.5.5.tar.gz"
    sha256 "001547e68f6e7fcf0f1cb83f7e82f48aa7d48b2c6a321f0cd20a853a8a2d1664"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~PYTHON
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