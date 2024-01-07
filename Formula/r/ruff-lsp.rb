class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https:github.comastral-shruff-lsp"
  url "https:files.pythonhosted.orgpackages9f9433db7ee5edc9935a21a79c79d1dba7b08b93c8de97b29e98c43ed64053e8ruff_lsp-0.0.49.tar.gz"
  sha256 "dc18046d7fdc81477435fe7b58407ba13964d2d1b67b8cd337d280f47dc405f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e857b222c03b96c7e80dd067e2fbcb61b7ad095291cfc7d1a36d1919d1c0e46b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c98b010656e64c5aa0c9388766a84113d86d6da3942f1096d9cac75256e45b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c949e4b288490d0fdb6dd87dbc7d8209254c1d0d01dea9657c2aaa80fb625e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7acd85babdffe9b3f4ed7fa37ec3d0f239e6e82d02044a3bd56516e50b07300"
    sha256 cellar: :any_skip_relocation, ventura:        "37488a69672b7b856ca40d40079be68c3f8dd1184c3ff68247d919bafcfe77c7"
    sha256 cellar: :any_skip_relocation, monterey:       "605950504f6ba6e28f7ec09144c40fdd1ced491168d9c51cde2c8878c69efde3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eaba2b5ebe19a383dc9fb17d3ad259f374bd59877b61393ebc1ae1196de2bc9"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages1e57c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https:files.pythonhosted.orgpackages3efef7671a4fb28606ff1663bba60aff6af21b1e43a977c74c33db13cb83680flsprotocol-2023.0.0.tar.gz"
    sha256 "c9d92e12a3f4ed9317d3068226592860aab5357d93cf5b2451dc244eee8f35f2"
  end

  resource "pygls" do
    url "https:files.pythonhosted.orgpackagese694534c11ba5475df09542e48d751a66e0448d52bbbb92cbef5541deef7760dpygls-1.2.1.tar.gz"
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
    output = pipe_output("#{bin}ruff-lsp", input)
    assert_match(^Content-Length: \d+i, output)
  end
end