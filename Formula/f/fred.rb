class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/dd/2c/51a14730b2091563018e948bf4f5c3600298a966c50862cd9ef98bee836c/fred-py-api-1.1.1.tar.gz"
  sha256 "e2689366a92f194f8f85db15463153a2116f241459ffc07d0bb5bbd5fb00837e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a50e24059e5934931b624416a8629772d499ffc3ad87fd038dc250ed9ae85b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9c8ce83fdc21f6f7ae542d188e370f36c4a0830735722f992f038c11156e0bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8ed5e8c7178e4deaf8a9b75e5329e01330c2001fb0c521db8d4095ca69e8fb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ff09f3adcd41215e36e142743f417a1b52935033259bdf58ad59e47da6633af"
    sha256 cellar: :any_skip_relocation, ventura:        "61f9d966633b1e39cc0a6a9297a76c63a817b1df16895855695ad503dd13814c"
    sha256 cellar: :any_skip_relocation, monterey:       "faa44d84025d387c65798b6cd14fd7e0014afe3b4c0ec3d438919ac5a864ca22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcd60b0e6fca55d04551575b3497c4c3d0baa9c21c488d6db57308783f455143"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    assert_match \
      shell_output("#{bin}/fred --api-key sqwer1234asdfasdfqwer1234asdfsdf categories get-category -i 15", 2), \
      "Bad Request.  The value for variable api_key is not registered."
  end
end