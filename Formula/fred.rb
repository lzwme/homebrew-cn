class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/1e/7a/bb49f22f2ce33109ce5a5f8c7b85263cbc97bf9c9b44ba612c8380d3406f/fred-py-api-1.1.0.tar.gz"
  sha256 "f1eddf12fac2f26f656e317a11f61ec0129ba353187b659c20d05a600dba78c8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8089f9a6cdcd59750673d84ad88aa811639e88f036704f1107f3e48a40491eca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f168772e0d637f443c555e0fa6445098706341e56e9d7c52f2771cbc5caef120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ece532d86ad5fdd6bce5476c120970ef1c4e7f7fd477ee429125b980d2fd5fea"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cbe4a72d8e0ca0f81f580e111dc19aa3f43fa09ed3c93b4fcefb919c41a694"
    sha256 cellar: :any_skip_relocation, monterey:       "f203b834fd464b8bc395cbc3a6d6890cbe9400ed42b6b6b50591872a9c128f2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e13403a725b96211a3fd12b2bed0f25c875e933ca47ed4318c2e2505418dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc9466ca6f4685a141923f807395397b11593814b2ac01c0295bc76c99bcde6"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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