class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/46/0a/e432b726310859b577e64bae2b5ee8ee6bef32741d63fdb9791a250a2271/ruff_lsp-0.0.43.tar.gz"
  sha256 "5b495c8282955a783200d36c1ae2dce2fa6b4f0df110ec7e6eba07d13bc8681d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93be91cd8acc876890d13845d85432dfebcefbc094d94f46932b2093fcfe77cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5deb66dd429e51fe8b0a51657718d968c7502a5fb1110249dce6fd846e15e548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa217ca9d6cd51192ad7893eade79d8776a3a20f1066c9dbdb15985c2b906fff"
    sha256 cellar: :any_skip_relocation, sonoma:         "f089255cdd344e2d44d42e1bbc44711ef96f431b1eadf5185a5429c7868e3507"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a578613d30e4cc44753be7d3fdbf522324a2cd0106fa8b72479e6b7661cf31"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfb7039c7ec9ee8acf5e9300bcfa90ea23a8c8702d46de05ffa37a7472b626e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2de31525acfc05f8fd50cd51ed02e0b2dbf2eb08f82b2e83c4b104a86fcfad8d"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
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