class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/cb/5b/5beed11bdabb27bc919dbd4fff128262992be4302a5ad18f1576a00b11a1/ruff_lsp-0.0.45.tar.gz"
  sha256 "11c2d4979eabf81327b714f9395b91be1f3620a8861009ae4967f67e7de2671d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef974c1d157e0a72a1eeac105eb8ab9bffc63db30b21b371937c3041dca6c21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91adba163bebd6f650bcfaae7b4b8c8ee7088d3fd58bd40d5b028eea6ace5486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd604f4c33784da95d7851acee2da02a464ca4226970c69417230a550a9e097b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cf3bdb76be3a1a0734b83638d3dd5f35bbe22bd394a6f99be6d34cee38e6818"
    sha256 cellar: :any_skip_relocation, ventura:        "41c60098aa2952fa1832143c4a21629fe446011c09600b6171579710e95a6029"
    sha256 cellar: :any_skip_relocation, monterey:       "8b38bb37e30a0e03cdaf0e4dc358066d9456fb61ebe53d198ca509e6acefbf22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687629d2909573881ece8e740afbb05e3e9f98a090c8036a2eb6a27c3aeacfec"
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
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/22/a1/4df53bbe3663de65ad90c6bbc2e6e8779b61fba1e13ee9a21a0f2f7db8f9/lsprotocol-2023.0.0b1.tar.gz"
    sha256 "f7a2d4655cbd5639f373ddd1789807450c543341fa0a32b064ad30dbb9f510d4"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/cb/d3/2d96ac29bbff44a2d37d43da67075c919d8f66870da0dce507f84d32d08f/pygls-1.1.2.tar.gz"
    sha256 "93fe17c01fd03307774290e685e7fa25bc1411cd72f243ff33eef21927fd0ad5"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/90/fb/e5d68ef7b0bca67d06bb4a15f9317decbd1a3f323c3d89221d2ca4c11512/typeguard-4.1.5.tar.gz"
    sha256 "ea0a113bbc111bcffc90789ebb215625c963411f7096a7e9062d4e4630c155fd"
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