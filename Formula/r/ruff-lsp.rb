class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https:github.comastral-shruff-lsp"
  url "https:files.pythonhosted.orgpackagesaaff68b1dd0bf5bce5d4bfbad6fcfddc7fc46ea070e0d191aa9a2972acb51f8aruff_lsp-0.0.54.tar.gz"
  sha256 "33e1d4dd20ca481fc6a811afcfdd451798c22fc39f2104df23c2855e322a0582"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, ventura:        "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc45410fa35f1db0a2ad25bd8dbdead0886677eda510e7b7334b46919cf83bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc72a3dbe7f95f695d8334d5a17da20dc467244ea2c03f1303f4337609d37eb"
  end

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

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pygls" do
    url "https:files.pythonhosted.orgpackages86b941d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5cpygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
    output = pipe_output(bin"ruff-lsp", input)
    assert_match(^Content-Length: \d+i, output)
  end
end