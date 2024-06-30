class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/85/f9/b044e398b4fe6de8d0173091f18e72e9c3dcf0f30c85f127bfc5f6a6b375/instaloader-4.12.tar.gz"
  sha256 "0e3fa65dd4b033f2ef6022a04f95fec18e0258535aee985d0643895713f2eec3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, ventura:        "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4813cf7572418d8263b7401cf4adf6f21183a081adefc1ae3e3faba0064088fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f357109ab16e90602089beca3086e31de4b26aac95b80e38faafe2d6e9c7876"
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