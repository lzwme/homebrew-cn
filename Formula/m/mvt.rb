class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https:docs.mvt.reenlatest"
  url "https:files.pythonhosted.orgpackages0ba7e12932647247b7cd253698e6aa0d5f831700d3dd7688c366af85eb255b62mvt-2.5.3.tar.gz"
  sha256 "5727877815b3d5a2a98e21a6be9da51c3629eb548e424457e9e78ae183344264"
  license :cannot_represent # Adaptation of MPL-2.0
  revision 1
  head "https:github.commvt-projectmvt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a194e0740eda32553525dbe106c93fba090603384e10b1c1025d0f5a25b311bd"
    sha256 cellar: :any,                 arm64_ventura:  "3b71b307c051aa8def0ee12e0ee0b70980dea21b5399cb226d1695f2a180161a"
    sha256 cellar: :any,                 arm64_monterey: "fe3e1e1d074321b9bc9e718a7ec9d14a7ff43f1dd56aba2ecf83c851092d5071"
    sha256 cellar: :any,                 sonoma:         "e0cbc9a61e41272d705fef29ee42dd56db4f9c51c4dd202b71444e0d8e945f04"
    sha256 cellar: :any,                 ventura:        "d4b6f437958f23de29725cb5f552aaa5993270154a801655e97c1cef9968b3dc"
    sha256 cellar: :any,                 monterey:       "64b879f93fe8efef83bd01e81686907b0a8133f0b6ce3d8cc8e8be2b7229414b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fecc6242df3514909a1789553cf3e38e584be35153e71e5f1e49d89d1984d0bb"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "adb-shell" do
    url "https:files.pythonhosted.orgpackages8f73d246034db6f3e374dad9a35ee3f61345a6b239d4febd2a41ab69df9936feadb_shell-0.4.4.tar.gz"
    sha256 "04c305f30a2ca25d5c54b3cd6ce9bb64c36e5f07967b23b3fb6aaecc851b90b6"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iosbackup" do
    url "https:files.pythonhosted.orgpackagesdbb84cd52322deceb942b9e18b127d45d112c2f7a3ec7821ab528659d4f04275iOSbackup-0.9.925.tar.gz"
    sha256 "33545a9249e5b3faaadf1ee782fe6bdfcdb70fae0defba1acee336a65f93d1ca"
  end

  resource "libusb1" do
    url "https:files.pythonhosted.orgpackagesaf1953ecbfb96d6832f2272d13b84658c360802fcfff7c0c497ab8f6bf15ac40libusb1-3.1.0.tar.gz"
    sha256 "4ee9b0a55f8bd0b3ea7017ae919a6c1f439af742c4a4b04543c5fd7af89b828c"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nskeyedunarchiver" do
    url "https:files.pythonhosted.orgpackagese8d9227a00737de97609b0b2d161905f03bb8e246df0498ec5735b83166eef8fNSKeyedUnArchiver-1.5.tar.gz"
    sha256 "eeda0480021817336e0ffeaca80377c1a8f08ecc5fc06be483b48c44bad414f4"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyahocorasick" do
    url "https:files.pythonhosted.orgpackages062e075c667c27ecf2c3ed6bf3c62649625cf1e7de7fd349f63b49b794460b71pyahocorasick-2.1.0.tar.gz"
    sha256 "4df4845c1149e9fa4aa33f0f0aa35f5a42957a43a3d6e447c9b44e679e2672ea"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackages192b678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name == "iosbackup" }

    # iosbackup is incompatible with build isolation: https:github.comavibraziliOSbackuppull32
    resource("iosbackup").stage do
      inreplace "setup.py", "from iOSbackup import __version__", "__version__ = '#{resource("iosbackup").version}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath

    %w[mvt-android mvt-ios].each do |script|
      generate_completions_from_executable(binscript, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mvt-android version")
    assert_match version.to_s, shell_output("#{bin}mvt-ios version")

    outputandroid = shell_output("#{bin}mvt-android download-iocs")
    outputios = shell_output("#{bin}mvt-ios download-iocs")

    assert_match "[mvt.common.updates] Downloaded indicators", outputandroid
    assert_match "[mvt.common.updates] Downloaded indicators", outputios
  end
end