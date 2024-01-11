class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Your Gateway to Embedded Software Development Excellence"
  homepage "https:platformio.org"
  url "https:files.pythonhosted.orgpackages5611843e9088f60049f32d438baffae4cdad334b25e59f46031e2b0673e7414fplatformio-6.1.12.tar.gz"
  sha256 "9ec61e65a0eea96e625e783b516f6eb2c534ecb43136b13a2d2b4ed527743808"
  license "Apache-2.0"
  head "https:github.complatformioplatformio-core.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6f912ee43f2a55362619e20d8c6760676409976b4069b0211ba458214109cd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e125b6004c09423824a3bef9c04ef4e1226faa8bd019bc207c987464b3534459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feff1f9d0e6ae4c82e7df63eaacbdb08405caa494ac05341a0012a9889df27a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9006e806035b2c23ef01b69ce86fc144e1a07ba049b99ab4916ce31025e558aa"
    sha256 cellar: :any_skip_relocation, ventura:        "c1796b9cc3d60220bd04f9a1ab152e6c09b22940067c1588c3788c1917250cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfd743c05bac26f88ba9d699bdc3a98dc9f9fcdddc4833fc6d0dffe9978900f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b9ac37022a18e6e63f917c30ec44e0f26c76021331f9e97a1b82fd7321b1883"
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

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages0381763717b3448e5d3a3906f27ab2ffedc9a495e8077946f54b8033967d29fdmarshmallow-3.20.2.tar.gz"
    sha256 "4c1daff273513dc5eb24b219a8035559dc573c8f322558ef85f5438ddd1236dd"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages8405fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
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

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages4f36168ba6d56a28382f3b081b23b0cc431de35786e120b94c1f372708ed3059starlette-0.34.0.tar.gz"
    sha256 "ed050aaf3896945bfaae93bdf337e53ef3f29115a9d9c153e402985115cd9c8e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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