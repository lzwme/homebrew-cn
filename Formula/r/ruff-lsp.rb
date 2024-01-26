class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https:github.comastral-shruff-lsp"
  url "https:files.pythonhosted.orgpackagesfa9917188370c07a58139e40ed16e93076a12ccb45b8ded0376ac61207262b7fruff_lsp-0.0.50.tar.gz"
  sha256 "e16b496c1ba82f29d7e9b9c24add835998f323795a746f507ea8f967346b916b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c432b01a130e2662aa6f5360af4b68099248c324fbd72674d4347e54affd2440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cabd668a1d6511034d0bb4625eafebb8335b80333a267fe1ceea8017128506ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c674af7f2440c59de2af4f166c130df573a3348b0959e3cc2ea7f7180f2a0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f1e576315ee22c17c68b961c7b2ea5078545f70085d4e9a25f1c642fd7a5922"
    sha256 cellar: :any_skip_relocation, ventura:        "c2d9abb1a1d765780f64eff5d816fe12239d2c5431fbefccbe1cb4c0b62003a0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1300bf057dee6b331247026a639cf2836b6792482883aefb4d6f34d59b1ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b03cc54611e272e1df0ca70aaf8d011937f8dd16cd0c17f53176a0562b2615"
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