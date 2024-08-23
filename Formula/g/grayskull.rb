class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https:github.comcondagrayskull"
  url "https:files.pythonhosted.orgpackages01ed8262d7838937c69e1f67c24a74787ffca5be0ae15fb40c3d79852345eea3grayskull-2.7.1.tar.gz"
  sha256 "e721eafec790e029651951fda0c744801b5b6bfcc42d1351c9debedbb3197f9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de7bf0d3962ce093b8eabebe0f1b5bf99f40011d890020068ac6d21ee71ca17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95859ac043e7bf1d3aadb6e9b109fd6b778c5573621b54fdfb0d15b2f1947f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26de47ffd2725d7eeefec0d52fcd94b38ae472dd2835834f207ed5fed3a13100"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9f40713bb5a896512cceee5a356b26421353fa7f6f2b5b2f2d0c9a28e32a553"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2fdd09e186bf04a751c41fb7b71f5262b2eeba3b5c8a8e445e82520eaba43a"
    sha256 cellar: :any_skip_relocation, monterey:       "416ad73ec2c6e7c5510ee8e970f7810b83c619b8facbf4809319e25ec7e560d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a0c0c5cdcb687bcaae9280c7f04aa2c9af37fe5f11e30d8cce8e912784c221"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages4fa1f00755330cb34bc19b1ba744b9880c51a9b1ed8526039354736d5f4dfb0dpkginfo-1.11.1.tar.gz"
    sha256 "2e0dca1cf4c8e39644eed32408ea9966ee15e0d324c62ba899a393b3c6b467aa"
  end

  resource "progressbar2" do
    url "https:files.pythonhosted.orgpackages417b42c1cec1218b8b9289d6c84bc9d874df1f06db642ad3350d01a4116de834progressbar2-4.4.2.tar.gz"
    sha256 "3fda2e0c60693600a6585a784c9d3bc4e1dac57e99e133f8c0f5c8cf3df374a2"
  end

  resource "python-utils" do
    url "https:files.pythonhosted.orgpackagesa70c587d2274217c13e9d1ba091560e9161ae94dd04053b390d70ef612b0af81python-utils-3.8.2.tar.gz"
    sha256 "c5d161e4ca58ce3f8c540f035e018850b261a41e7cb98f6ccf8e1deb7174a1f1"
  end

  resource "rapidfuzz" do
    url "https:files.pythonhosted.orgpackagese8b0e0756b5efe826c1bdf6442777cc924b41258685dcf372ee77399cc10408erapidfuzz-3.9.6.tar.gz"
    sha256 "5cf2a7d621e4515fee84722e93563bf77ff2cbe832a77a48b81f88f9e23b9e8d"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8d37f4d4ce9bc15e61edba3179f9b0f763fc6d439474d28511b11f0d95bab7a2setuptools-73.0.1.tar.gz"
    sha256 "d59a3e788ab7e012ab2c4baed1b376da6366883ee20d7a5fc426816e3d7b1193"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
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

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}grayskull --version").strip

    system bin"grayskull", "pypi", "grayskull"
    assert_predicate testpath"grayskullmeta.yaml", :exist?
  end
end