class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff-lsp/archive/refs/tags/v0.0.35.tar.gz"
  sha256 "49e2ce87b266c162056e65f121457f193956a6299360a87e45de623b5f697a09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6d958e83118ba75b9bcce40615f0bfab778a7af306ecc7499ce62722208015d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "338884417c6175e2ec556661ad72b3afa6d6bb47187398c197961a3f70f44794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee11619b033915e4a472bd17c05e119d3beffabbe7be4b386e216d9e54d4733d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b2f0620f7625e4bff86140aa9216ad923ec8f244200caa11e3c2bc2c7342088"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf8667fa668cf1f954c28634d0d58e7365277d0ec64f8b56f8bc4801717ee32"
    sha256 cellar: :any_skip_relocation, big_sur:        "21705992cc225f284d5f01502f9ca105f0bf65670890c0da1aa634e40a94e560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b62008ccb994e459d8bd1a5a45131038837ba7326d60cf460411c0dc561091"
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
    url "https://files.pythonhosted.org/packages/f3/70/4e0e841e35ac450ca7f994020887c05aeb4d0cd25e8d53901f448dd43acb/lsprotocol-2023.0.0a2.tar.gz"
    sha256 "80aae7e39171b49025876a524937c10be2eb986f4be700ca22ee7d186b8488aa"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/bb/c4/fc9c817ba0f1ad0fdbe1686bc8211a0dc2390ab11cf7780e9eeed718594b/pygls-1.0.2.tar.gz"
    sha256 "888ed63d1f650b4fc64d603d73d37545386ec533c0caac921aed80f80ea946a4"
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