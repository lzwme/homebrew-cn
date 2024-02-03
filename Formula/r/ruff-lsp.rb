class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https:github.comastral-shruff-lsp"
  url "https:files.pythonhosted.orgpackagescee2eb9b7d3ab17b0192f606faf67a69826dfb755e9ab97697e7dcaf952a50dbruff_lsp-0.0.51.tar.gz"
  sha256 "6411486a0c304d44153c09dca2636d84c692d206799ee61c4942981d2c503eb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c974f3f13c993587f21df2a2566ae4b1d47e0ee24c1d99896ed43a5ab2ea8a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88a6ae916be2fe25d027ac4ff5c5ef3d811bee65e689b4818c7733f7c308d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c40381d0f85ba2a945d6e2f0864f466970b91d8bd8bd1a31ca3dc9a0865ab8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c647f9d974e4267fcef00da3cc4d8646e4e98b1734f35582a46ebe1bc232a110"
    sha256 cellar: :any_skip_relocation, ventura:        "94b45d054cf38ec045ce148a9b2bb7e92a1acaba91941541e3481bbda3112d25"
    sha256 cellar: :any_skip_relocation, monterey:       "acfe4810026ad3df10409a1d5171957deaabc53a88ae825b6478778c7394febe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd02467f5b1bee86f8e71fff5c92941276459e387a0d11a70e9d27634db8164"
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
    url "https:files.pythonhosted.orgpackages9df66e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6flsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https:files.pythonhosted.orgpackagese98d31b50ac0879464049d744a1ddf00dc6474433eb55d40fa0c8e8510591ad2pygls-1.3.0.tar.gz"
    sha256 "1b44ace89c9382437a717534f490eadc6fda7c0c6c16ac1eaaf5568e345e4fb8"
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