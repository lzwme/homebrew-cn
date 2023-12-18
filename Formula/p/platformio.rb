class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Your Gateway to Embedded Software Development Excellence"
  homepage "https:platformio.org"
  url "https:files.pythonhosted.orgpackages859b37452c9b7e99638c9d761c7864a463e4721ce7206fb526174813ffe6a949platformio-6.1.11.tar.gz"
  sha256 "1977201887cd11487adf1babf17a28f45f6dbbec8cbc5e3cc144cb43b320a0d0"
  license "Apache-2.0"
  revision 3
  head "https:github.complatformioplatformio-core.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a554233014e2c5161ec3578c60411e4b8a60ed9edb7530c09d5fe011f081f65b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aefb1e36ab188a71be586374b7522e857adf1040da3f9bcb0242d4a069d5f389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b03298518271ac24ff19cd0faa153f4ae2d7e8591e99892c79f5c1c55b886c"
    sha256 cellar: :any_skip_relocation, sonoma:         "014c6d1bc38e1d954ea13e5371a1107129c7310fa17e194815d90f01caf783f8"
    sha256 cellar: :any_skip_relocation, ventura:        "bb52be700a428304a6c96dcc088507a8e501346b150f191ca3a4ba41b95bef89"
    sha256 cellar: :any_skip_relocation, monterey:       "218a03ac5b5dbdb9b3c56d727bb88b14e54e76bdfc938102b0fb82884012fb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a461d391078f9c6a2738eb0939d714a3138b28bf88e5a13138dfaab7ea360a60"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "uvicorn"

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackagese4e03e49c0f91f3e8954806c1076f4eae2c95a9d3ed2546f267c683b877d327bmarshmallow-3.20.1.tar.gz"
    sha256 "5d2371bbe42000f2b3fb5eaa065224df7d8f8597bc19a1bbfa5bfe7fba8da889"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages0e35e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5epyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackagese14bfcd426d9477554d31dacb0c8069828466841b69ad26c8cfab9c5321830ecstarlette-0.31.1.tar.gz"
    sha256 "a4dc2a3448fb059000868d7eb774dd71229261b6d49b6851e7849bec69c0a011"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    pth_contents = "import site; site.addsitedir('#{Formula["uvicorn"].opt_libexecsite_packages}')\n"
    (libexecsite_packages"homebrew-uvicorn.pth").write pth_contents

    generate_completions_from_executable(bin"pio", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end