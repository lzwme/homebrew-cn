class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/d6/71/87b6d26ec53faf00ce00936a13da7e59ecca77f52263638e8e5d3e637a53/instaloader-4.13.1.tar.gz"
  sha256 "36774ea1076eeb236f8782d221e3737f71ddc023042f0b13761429ef137f1133"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88fcb2a8e907aa96666741cd69b47232df252b75a4fe339f2889680230972d4e"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/e8/ac/e349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72a/idna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
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