class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https:github.comanchorevunnel"
  url "https:files.pythonhosted.orgpackagesa028cd9eff639860bc6c748b152320d6ffd10ccf0fdb5dbdcc86459d8dac600bvunnel-0.22.2.tar.gz"
  sha256 "1ce0357e2c54c2e508470fdc5fab3b8364ac0520ad46523e0885f08a0d75e1de"
  license "Apache-2.0"
  revision 1
  head "https:github.comanchorevunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2a551e8b8409b476504531cae0d43987d73675ea5d7fb629541cc3eef9915f8"
    sha256 cellar: :any,                 arm64_ventura:  "30f55d8879676115aee84ced41e33b12191ed6aa2e668ae22bcb0c5c29d8dd3d"
    sha256 cellar: :any,                 arm64_monterey: "6d92f25add55aca0c695cc1f23ab6d4910aa37011eab23e7662444f536ffe27a"
    sha256 cellar: :any,                 sonoma:         "779921a7c7fc0f80222cfca0f94d3e114ba4649f4ba37a61948383ff48165788"
    sha256 cellar: :any,                 ventura:        "a116f133c74801439225e921c1492ee708ed0f2f3c951fbf74ad0223f034ebf9"
    sha256 cellar: :any,                 monterey:       "ec0d9ecff491dba4ffd4a3cae784a063e826b7aa3de06afc2b2967b6ff115a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91495fe264c54eaac328daae858f1e8a33c713fdfdac5e3d3ab4e62df696e69f"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesdb382992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "cvss" do
    url "https:files.pythonhosted.orgpackagesf0c13ec60fa39d598bf652871f012cf8fd7e85f80ca6b2243c312c84a96a1314cvss-3.1.tar.gz"
    sha256 "54789edd255d1bc26cc04919f5795e250e9ce2da33b2fc0e8e709f22cb88c5fc"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https:files.pythonhosted.orgpackagesf444aba2c40cf796121b35835ea8c00bc5d93f2f70730eca53b36b8bbbfaefe1docformatter-1.7.5.tar.gz"
    sha256 "ffed3da0daffa2e77f80ccba4f0e50bfa2755e1c10e130102571c890a61b246e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ijson" do
    url "https:files.pythonhosted.orgpackagesd0123116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseae23834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mashumaro" do
    url "https:files.pythonhosted.orgpackages85fea6b35aa5fbb500892cc0ec24543bc54941a9c8855aeb1a78362c0a0b061dmashumaro-3.13.tar.gz"
    sha256 "636c31afe39d991efe4cad269fef0c8ba408d87581118784d2a47924c2073faa"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackagesf816c10c42b69beeebe8bd136ee28b76762837479462787be57f11e0ab5d6f5dorjson-3.10.3.tar.gz"
    sha256 "2b166507acae7ba2f7c315dcf185a9111ad5e992ac81f2d507aac39193c2c818"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages099d78b3785134306efe9329f40815af45b9215068d6ae4747ec0bc91ff1f4aapytest-8.2.0.tar.gz"
    sha256 "d507d4482197eac0ba2bae2e9babf0672eb333017bcedaa5fb1a3d42c1174b3f"
  end

  resource "pytest-snapshot" do
    url "https:files.pythonhosted.orgpackages9b7bab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruff" do
    url "https:files.pythonhosted.orgpackages2f2f1e91c17c5223a37992a9302af69056966657d23f945e07039319fe006f82ruff-0.4.4.tar.gz"
    sha256 "f87ea42d5cdebdc6a69761a9d0bc83ae9b3b30d0ad78952005ba6568d6c022af"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackages8aa4b5991829c34af0505e0f2b1ccf9588d1ba90f2d984ee208c90c985f1265aSQLAlchemy-1.4.52.tar.gz"
    sha256 "80e63bbdc5217dad3485059bdf6f65a7d43f33c8bde619df5c220edf03d87296"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackages69198e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678btoposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "untokenize" do
    url "https:files.pythonhosted.orgpackagesf746e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "xsdata" do
    url "https:files.pythonhosted.orgpackagesb4ef35d8118f903510f9e028f8a6a4edb615fa69e28a30d955593425a88e587axsdata-24.5.tar.gz"
    sha256 "4e8414a01bff603ca38a361d04d819934fcc525f9b4220f0076e040d84a4a963"
  end

  resource "xxhash" do
    url "https:files.pythonhosted.orgpackages04ef1a95dc97a71b128a7c5fd531e42574b274629a4ad1354a694087e2305467xxhash-3.4.1.tar.gz"
    sha256 "0379d6cf1ff987cd421609a264ce025e74f346e3e145dd106c0cc2e3ec3f99a9"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3eef65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackages5d912162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fazstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  def install
    # Fix compilation of ijson native extensions, note:
    # This would not be needed if latest ijson version is used upstream, but there are reasons it is
    # currently held back: https:github.comanchorevunnelpull103
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    virtualenv_install_with_resources

    generate_completions_from_executable(bin"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vunnel --version")

    assert_match "alpine", shell_output("#{bin}vunnel list")
  end
end