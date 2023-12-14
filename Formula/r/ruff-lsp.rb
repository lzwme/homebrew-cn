class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/1b/90/1eb29f87d0e50136dcd013282efaa1939ce07d971c08ebcfaa5f857cb178/ruff_lsp-0.0.46.tar.gz"
  sha256 "37e1e7b40b2ea0309a1e97e46b016c426d1df6b51664a2af9024edda25a1032d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6bb3958c96950906e7a7d0f3aa37484a8c104bcd4edb062ad3c4ae510ebb77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4219fbabdeb98339444fa5c86e461778904296132d79f776bdb080f2505c4e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754f946c43a5539d7fef628a427cb030a3aeb3e177c50c6f1b24f0b80a1138b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b33689ba0869f4b2027f93878beb12d10a043b015acd574dee1cef8e9fcf5d6"
    sha256 cellar: :any_skip_relocation, ventura:        "0dfabb42e842d61c0a157ecbcbdc0e2e4bae767116ab0fa79b56f6be4f6a096c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1797b3adbc8b3c28180710f2988c15157161da98598213ce0c9d1ad722373f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4780b7197cc7136dd67e80ed276bbed04d753ad0100364a388382302f04b70d"
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