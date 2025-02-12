class Jsbeautifier < Formula
  include Language::Python::Virtualenv

  desc "JavaScript unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://files.pythonhosted.org/packages/cf/74/a37cc6fe8ab3f217657d345dfba0612758807536dca5ca5d2f6a81e3623d/jsbeautifier-1.15.3.tar.gz"
  sha256 "5f1baf3d4ca6a615bb5417ee861b34b77609eeb12875555f8bbfabd9bf2f3457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f26c3a774e92e6146da1ba23fd9292346e2fad5cdc2cca362e7da1cb885c3c9"
  end

  depends_on "python@3.13"

  conflicts_with "js-beautify", because: "both install `js-beautify` binaries"

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/b4/29/785595a0d8b30ab8d2486559cfba1d46487b8dcbd99f74960b6b4cca92a4/editorconfig-0.17.0.tar.gz"
    sha256 "8739052279699840065d3a9f5c125d7d5a98daeefe53b0e5274261d77cb49aa2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    javascript = "if ('this_is'==/an_example/){of_beautifier();}else{var a=b?(c%d):e[f];}"
    assert_equal <<~EOS.chomp, pipe_output(bin/"js-beautify", javascript)
      if ('this_is' == /an_example/) {
          of_beautifier();
      } else {
          var a = b ? (c % d) : e[f];
      }
    EOS
  end
end