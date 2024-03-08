class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/b9/4d/5997ff747d69b8451a63b92182eb3df42a87a171e0a1c8acc2792bc8afc1/fred-py-api-1.1.2.tar.gz"
  sha256 "361886a97b8016e3010557e2c2e60f5656f2192f37eae05fa53867c6c3b0653c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b6b5f850e90e317ca29a30a683eb2df196be90d72066b2322e3a7e924be8db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac34d3d7308efd0edba2719bda19ea568ef1d4f3031cbe75d9853f1e9acfaf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff7fced582033848c54d21d0335f658c78f5d945242b28e56f20db076c71319"
    sha256 cellar: :any_skip_relocation, sonoma:         "358fe4c02392dadd4a6ea662574f279c6d53d30ccb5b26fa16b12657d6c422ca"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7d885f1df23fd931083036d4dc9467d48b3eb876a2d4cf4f7029398f4cd47c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd1db482695592c7a757c938b95385d997dd8265f4551846ac5290d1bdf4394e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8022ae63417b65e9cc9e1a76498ea4ac5ba347e2d3e3ea7951ec194257f227f8"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end