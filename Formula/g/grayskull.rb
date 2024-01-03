class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https:github.comcondagrayskull"
  url "https:files.pythonhosted.orgpackagesdf39061c968df5b80a3582b3a20b8a734ece2dafaebd01db7e58cb7e15498c55grayskull-2.5.3.tar.gz"
  sha256 "1a82d476fe2b0c486d00aea20a32c688a6e24ccd74b1b4aa3b336723e50434b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48751e01d2cb0a6f284c21605aafac1c40c6756c8cf2668af14cc876b56198ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5351d0bf2d1e20cd9d2d8b626e8025952a49d3ee222e2085e2cf1c78933eb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02d34cfca128c3629a8126fc5965b6c9d3334b37ae25e95c3d7b31de2080ff1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eba688acbc06cb7978be4614e13085e12dfb3fc16a4ba472c3589f79889a7825"
    sha256 cellar: :any_skip_relocation, ventura:        "af3d981bcf1b5915e4d07e9b1bc839655307858970e98e7487e00acfc0bdcfbd"
    sha256 cellar: :any_skip_relocation, monterey:       "739b67018acd6c3ea95dc421eb003e413f526766953af23f79ec7ccba3ac3545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e84ab9bae1a8e8e46c7b823d907537c26eb78644835938e2e4a7c500b51b0f4"
  end

  depends_on "cmake" => :build
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https:files.pythonhosted.orgpackages786ac4d067f8ef39b058a9bd03018093e97f69b7b447b4e1c8bd45439a33155dconda-souschef-2.2.3.tar.gz"
    sha256 "9bf3dba0676bc97616636b80ad4a75cd90582252d11c86ed9d3456afb939c0c3"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesb41c89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "progressbar2" do
    url "https:files.pythonhosted.orgpackages685a66e4838702ee7152e89a03498409e5b47536e637da2df725600201748ee6progressbar2-4.3.2.tar.gz"
    sha256 "c37e6e1b4e57ab43f95c3d0e8d90061bec140e4fed56b8343183db3aa1e19a52"
  end

  resource "python-utils" do
    url "https:files.pythonhosted.orgpackages9ceb0a867dd2d8b0c7e5974990e7eea097e560f9689df93d0aa7902e412a690fpython-utils-3.8.1.tar.gz"
    sha256 "ec3a672465efb6c673845a43afcfafaa23d2594c24324a40ec18a0c59478dc0b"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagesd4f4039e35e99c967100d73616ec08d4c02325f67e0d5c32a6d5a49a7f620942rapidfuzz-3.6.1.tar.gz"
    sha256 "35660bee3ce1204872574fa041c7ad7ec5175b3053a4cb6e181463fc07013de7"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages8243fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782cruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "ruamel-yaml-jinja2" do
    url "https:files.pythonhosted.orgpackages91e0ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abffruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "semver" do
    url "https:files.pythonhosted.orgpackages416ca536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bcsemver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "stdlib-list" do
    url "https:files.pythonhosted.orgpackages39bb1cdbc326a5ab0026602e0489cbf02357e78140253c4b57cd866d380eb355stdlib_list-0.10.0.tar.gz"
    sha256 "6519c50d645513ed287657bfe856d527f277331540691ddeaf77b25459964a14"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages49056bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6ctomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}grayskull --version").strip

    system "#{bin}grayskull", "pypi", "grayskull"
    assert_predicate testpath"grayskullmeta.yaml", :exist?
  end
end