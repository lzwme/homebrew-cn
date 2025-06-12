class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https:docs.mvt.reenlatest"
  url "https:files.pythonhosted.orgpackagescb59ebec439c4f00a2a2f290fe5123e0d697024e43b7d8cf107a057c79cc7298mvt-2.6.0.tar.gz"
  sha256 "5ef62cac4c84f9b6707bfc83c47f33afdf8e6a2a16bf8156701c5595969b8c29"
  license :cannot_represent
  revision 1 # Adaptation of MPL-2.0
  head "https:github.commvt-projectmvt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4092f861896c006c689b1da9047a3df0d6dd3950d4ad408fc27f24b257c98bae"
    sha256 cellar: :any,                 arm64_sonoma:  "6e5dbf34333ebae041f760aa8593a18153aac79229b5a36b55b08d3d85d3ff9b"
    sha256 cellar: :any,                 arm64_ventura: "037a663bf1d80895ed5bc0a2fe196795d48d412eda41faa776a90fba8f834af1"
    sha256 cellar: :any,                 sonoma:        "2224a1133e6c4d35c8988ac92de4df214a401720b1674e483eeafe73ebe42346"
    sha256 cellar: :any,                 ventura:       "f2a34bb94db82e6d339a6e3349caac0d5ea28870f9d8ec127100ac71e16e5ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec85cb48daa16ab046be32631074f976600b277173c1b9644607422db497ca0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f730b1521e0b8fa8ead07212b90539531a9a3bf3b3c53af868d1173f1dd0de5d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "adb-shell" do
    url "https:files.pythonhosted.orgpackages8f73d246034db6f3e374dad9a35ee3f61345a6b239d4febd2a41ab69df9936feadb_shell-0.4.4.tar.gz"
    sha256 "04c305f30a2ca25d5c54b3cd6ce9bb64c36e5f07967b23b3fb6aaecc851b90b6"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iosbackup" do
    url "https:files.pythonhosted.orgpackagesdbb84cd52322deceb942b9e18b127d45d112c2f7a3ec7821ab528659d4f04275iOSbackup-0.9.925.tar.gz"
    sha256 "33545a9249e5b3faaadf1ee782fe6bdfcdb70fae0defba1acee336a65f93d1ca"
  end

  resource "libusb1" do
    url "https:files.pythonhosted.orgpackagesa27fc59ad56d1bca8fa4321d1bb77ba4687775751a4deceec14943a44da18ca0libusb1-3.3.1.tar.gz"
    sha256 "3951d360f2daf0e0eacf839e15d2d1d2f4f5e7830231eb3188eeffef2dd17bad"
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
    url "https:files.pythonhosted.orgpackages50688e48609f2c3554917d3c305e5ec9ba8f3d1ddcadba221d52c1f63b713dednskeyedunarchiver-1.5.2.tar.gz"
    sha256 "d9a2d5d48ea9e2c78d31bfbfc4a97c02794192f3b4548342d727d54bdd20beba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyahocorasick" do
    url "https:files.pythonhosted.orgpackages062e075c667c27ecf2c3ed6bf3c62649625cf1e7de7fd349f63b49b794460b71pyahocorasick-2.1.0.tar.gz"
    sha256 "4df4845c1149e9fa4aa33f0f0aa35f5a42957a43a3d6e447c9b44e679e2672ea"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesda8a22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackagesaf9251b417685abd96b31308b61b9acce7ec50d8e1de8fbc39a7fd4962c60689simplejson-3.20.1.tar.gz"
    sha256 "e64139b4ec4f1f24c142ff7dcafe55a22b811a74d86d66560c8815687143037d"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackagesdfa15723b07a70c1841a80afc9ac572fdf53488306848d844cd70519391b0d26tld-0.13.1.tar.gz"
    sha256 "75ec00936cbcf564f67361c41713363440b6c4ef0f0c1592b5b0fbe72c17a350"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    venv = virtualenv_install_with_resources without: "iosbackup"

    # iosbackup is incompatible with build isolation: https:github.comavibraziliOSbackuppull32
    resource("iosbackup").stage do
      inreplace "setup.py", "from iOSbackup import __version__", "__version__ = '#{resource("iosbackup").version}'"
      venv.pip_install Pathname.pwd
    end

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