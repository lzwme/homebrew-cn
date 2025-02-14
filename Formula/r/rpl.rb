class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https:github.comrrthomasrpl"
  url "https:files.pythonhosted.orgpackages3ebae65ee036e822b6aea002e3b5f36bceee6ce1238bfbe15d0cf544ae591894rpl-1.17.tar.gz"
  sha256 "6f1fbb7b4c9d033fc977501833d333d68a3d487986dbb717179d0dd4861de201"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e806d2c42dc8d1420cf01b83ab5550b2658a3c6c3179702b1541d644aca6955f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c70a726d8783bcc32fb4cf699408e7c8ae92d5a333753393c4c166e0674fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04a909a86e8fe5f6944b22e35e68e9916eeda813375e94f07b10a530f4114689"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4998c00f2183aef2e1e179b24df70f17f36fa3dcd97ed0c2b61ccdf70fd726"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed680b959b9e11320f58e42d4ce9d081cc612284e334ba414f7b956c217e267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a07f3dc7b549e7fa5d73a990467e948fc05dcc1de58160796c3098db56c5ae8"
  end

  depends_on "python@3.13"

  resource "chainstream" do
    url "https:files.pythonhosted.orgpackagesa5cc93357fd1f53c61fdc6111a6d9ea2cc565b2c1be9227c15bb036a0db0396bchainstream-1.0.2.tar.gz"
    sha256 "b32975d3b3d1c030a507ac298044c28fa3ca30d527abdfae281edd53276617b3"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test").write "I like water."

    system bin"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath"test").read
  end
end