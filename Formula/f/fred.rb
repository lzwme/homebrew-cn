class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/1e/7a/bb49f22f2ce33109ce5a5f8c7b85263cbc97bf9c9b44ba612c8380d3406f/fred-py-api-1.1.0.tar.gz"
  sha256 "f1eddf12fac2f26f656e317a11f61ec0129ba353187b659c20d05a600dba78c8"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "381204eea7616e7ce416e2a8a47af6306f30968449c5701d955d4f741494937d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "643d395f83bf5b9f0595ec50eedf0ad782d2f533d4c5c99f4e5c10e0ca07fc9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55863cba652f0583a23edc318c2a30d7f5be0af2788780248cce928d7f1916e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "dede5b061ca8324d18830b3f232cc65f9a28733e40fb35a1f2238d88cce5f6b6"
    sha256 cellar: :any_skip_relocation, ventura:        "ea203e8b23746ed4b4a489385c6fada7adeffb3b591e07422d29c090f447d6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a86a02d1f54385bf17183e1dd872e3c9c7335961e7d847d1d262a7c68ffa7e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5e87588a4deabf0f845b3dce53dc8e65d1548e92a574103bd5a545bfda6a2e9"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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