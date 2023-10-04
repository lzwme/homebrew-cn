class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/57/f0/e97753c41d07f90a3df653fe885c0ede54734e232728365e068573aaaa9b/ruff_lsp-0.0.40.tar.gz"
  sha256 "15e7b4a500a11cca34040348a689830ea5739dc2edb0ad51a05deec293bfacf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a8708674d50dcc5a697d02e75ad717bbf38a679e751c9c23f1c088d46c390d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf05f1dc699a28b06b4e096d37ad0839c353b015738644f5b2f4b6feba76927b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd534f02e1a245ab00b42480cced751cafcd83e52ed2eb3f6405b20ab273cad"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e03a6714609f7ccf7f823cea3eac0cdc3a58bea92eb3a325493ebf51ed8cff8"
    sha256 cellar: :any_skip_relocation, ventura:        "77abff0aa91e51f6e395462317b5ac7201316a0fa26c95715f4ac662d1e02227"
    sha256 cellar: :any_skip_relocation, monterey:       "8f12e56e7772ae5ea28034af69d2ec8bf174d6f85db58315944451cbc5b51982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3384cb7690d38228874ed16c5e4839140d3db3ea898e7c319822531fbc0fdd0a"
  end

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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/10/1a/4994d487a7295a7c834a81003b83b00b26086dbd3747699ed3eb20e73fcc/pygls-1.1.0.tar.gz"
    sha256 "eb19b818039d3d705ec8adbcdf5809a93af925f30cd7a3f3b7573479079ba00e"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/af/40/3398497c6e6951c92abaf933492d6633e7ac4df0bfc9d81f304b3f977f15/typeguard-3.0.2.tar.gz"
    sha256 "fee5297fdb28f8e9efcb8142b5ee219e02375509cd77ea9d270b5af826358d5a"
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