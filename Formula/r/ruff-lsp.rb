class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https:github.comastral-shruff-lsp"
  url "https:files.pythonhosted.orgpackages96b0ddbd3ead49d20741462874032c5238ee99be755bf9838c9f96470ddfbaa8ruff_lsp-0.0.57.tar.gz"
  sha256 "559b72ba460d0b90aab66ca11785b90ad8c6931509eb56db7dea2a8922bf41a8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b8322356abd470ee27ddd18114380716de176723e69fd6ef3a2740d4a819c356"
  end

  depends_on "python@3.13"
  depends_on "ruff"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages6465af6d57da2cb32c076319b7489ae0958f746949d407109e3ccf4d115f147ccattrs-24.1.2.tar.gz"
    sha256 "8028cfe1ff5382df59dd36474a86e02d817b06eaf8af84555441bac915d2ef85"
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