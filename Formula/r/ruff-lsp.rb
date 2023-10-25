class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/8c/c9/daf294304c8813ecca35ab3c2b9e865ef9af65c1978c587fd5bd7b068d3b/ruff_lsp-0.0.42.tar.gz"
  sha256 "249581bec445ccdffb313f8e6ef8ce20d14b8bba36a882a9d041c8334af68462"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1333c9dccff8e36fdbe228e7df0b09c6395bd21dfd008d7cd8753ea3c36e0355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c7f8b986ffecf8ccfc081905056b4b5e678b75aa98eafa539569e2a31b52fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4dc52f0f8fa16e47a07700a4215198fb50c824d5305f098520890ab2915ae9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce22240485c4a82bdcf892101a94887265e1542d0f7e1e0f3af73e1a2dbd2e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "4368c1328b82a9da949cc90ca9523dbb0080f94676f8ca898aca382a19c27c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "e61e8d1e730b8cac331911dd0a63fbdf59e12f921a88ad84c076e8162e0e548b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ff83500c0e6a583963565c334416a9dc62331d81c9d0a00659735a0955e5ac"
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
    url "https://files.pythonhosted.org/packages/b2/02/cedb2febde8ff53ec21d299159027dc8a9423118f2d3ab7151441a79e972/pygls-1.1.1.tar.gz"
    sha256 "b1b4ddd6f800a5573f61f0ec2cd3bc7a859d171f48142b46e1de35a1357c00fe"
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