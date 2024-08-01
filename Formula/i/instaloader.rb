class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/63/05/6290afa0f2bfb59d24b6193e26246518c660b489b925a87f1cdd3a176bc7/instaloader-4.12.1.tar.gz"
  sha256 "01d5b59cfc8c2f3188ed9bafb28c4ab4c47ceb407bc17e60462768861fc95d5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, ventura:        "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, monterey:       "5884038d8c9a9483d9a208db2242e36267453c756b2385e2ce4a4f48b23811b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48af73c3b23302ffb48f40eab04c21f8d75db70e5e859a0f359f4c193fe63a33"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 3)
    assert_match "Login error", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end