class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https:github.comcondagrayskull"
  url "https:files.pythonhosted.orgpackagesd52847137c83faf18a85d6782a099d4a6129097c20625d77c0bd75185296f493grayskull-2.6.0.tar.gz"
  sha256 "39ec33a74b716c4e3ed876733669866f1b0743a242e16255e772e793598cb2dd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94c3e7fe07bde79e40ca4232f5b15bc941c0836a48c0fe1e1f6f280bf40c771d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6874bc0823d02b9a31ddcb1304746199df02ff2df803476312c0573c491cd666"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79dac00115c9fe9e968c7a99eca14a960de2ea9a0fe9a3babfd43cab2b4b288d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ec992267eff9119fbd71ae51570111b8c40dd414b172fa812acc6aa6f473f65"
    sha256 cellar: :any_skip_relocation, ventura:        "9de6cfa57a87e4ca9b137e0b673deca58c21ab5afeb67da290f794c479a4246d"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e2845125ff9792cd112a3facbacf2c6ac4f49c2e58b5386b45a00d07b502aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787fed6cb90d48ad221840788cb52d92ce1ee200269366a58703a48ddb958034"
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
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackages2f72347ec5be4adc85c182ed2823d8d1c7b51e13b9a6b0c1aae59582eca652dfpkginfo-1.10.0.tar.gz"
    sha256 "5df73835398d10db79f8eecd5cd86b1f6d29317589ea70796994d49399af6297"
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
    url "https:files.pythonhosted.orgpackagese8949cf5188f6e13e58dec8a1f9f6bb201a66b42108de39ad239f6556ea7fc87rapidfuzz-3.9.1.tar.gz"
    sha256 "a42eb645241f39a59c45a7fc15e3faf61886bff3a4a22263fd0f7cfb90e91b7f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
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
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
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

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}grayskull --version").strip

    system "#{bin}grayskull", "pypi", "grayskull"
    assert_predicate testpath"grayskullmeta.yaml", :exist?
  end
end