class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/d4/ab/f0d2093dd56bc83320da90dbdd41ae1063cf2922bcab99cc640a05d5d797/ruff_lsp-0.0.47.tar.gz"
  sha256 "039989961d54ffa0d0702317de5022c5f68102fb8298d7e78050edbc63f14c84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7ba6aade6b40cd29a325dfccd73c31f777f73a9ab1e320c7e7167270bedbc50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807da5e0dd3db41a9dd7b7b42a16fda5ad3b121ba26a6beb50a87f6342a89db0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abfa73999916af83ed7cceb4fe37329d57c8a12968bd17d8e2e33f8c05ca06bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "cde9267d5df919e6dd24f9695e0a608981f8397e9b81c0691beda83e8da87c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "935a847a22438472b26ab11aa0e65e878473c1b2ed3d9c23672d29a210e605f3"
    sha256 cellar: :any_skip_relocation, monterey:       "df5d50683e507342f67acafd25e2838e39407a941d82db1eff5cce1ae928a019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aeeb53fae886c54cc3cc2ec78051c11cc95c369b0d00ecdb3f0539309ebe0a8"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/3e/fe/f7671a4fb28606ff1663bba60aff6af21b1e43a977c74c33db13cb83680f/lsprotocol-2023.0.0.tar.gz"
    sha256 "c9d92e12a3f4ed9317d3068226592860aab5357d93cf5b2451dc244eee8f35f2"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e6/94/534c11ba5475df09542e48d751a66e0448d52bbbb92cbef5541deef7760d/pygls-1.2.1.tar.gz"
    sha256 "04f9b9c115b622dcc346fb390289066565343d60245a424eca77cb429b911ed8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruff-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end