class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/7e/35/1f8d36c0656d4797fc5089c016995447f2b439e8fb9df02bf9d7873566fc/instaloader-4.11.tar.gz"
  sha256 "7478a1f0ed5c05911832c50cb19747243a461b5d434907f9fdb7d2d750d1b4f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f940102153dd74305faf4e9503aa6ad2696654aa55619fb391606c9daf5d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca62d32abd9285a6021907050c400d181ec6f15d79576812eff7cda9334d78a4"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end