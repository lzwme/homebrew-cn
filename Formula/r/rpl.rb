class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https:github.comrrthomasrpl"
  url "https:files.pythonhosted.orgpackages8d41b122e853b64ce9e539be9cb69e5955f73ba0b096d2ced15f5e56db6eada8rpl-1.16.tar.gz"
  sha256 "b81a732987dd1aeda3d5911ac384cdd5f1fe5bd54bac97fb6bceefcd90415376"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21fbbe1397c75585de173cc9ac41713132e7c06f8c772c0239199a3d4aad505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "984bfd891baffa48a330da55353fe16f9aff22eaee04f695383c7c43e2e2c881"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca6a8c3bfac2b63ecc04aeeac3deefc8cf82462011b7e09b5d9954583122cfd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "714ca8ae0b424e4efff0810076cd025e5b52e26a668c9cc7f18c1676187530de"
    sha256 cellar: :any_skip_relocation, ventura:       "920899906c6043557000d8c51a89f21fa9e68cd3f29f32a87cc25cc763affce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0044c74ca3d32031c2d3236360c7845e62c084445c5a9653a63d8e3c10f3d2a0"
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