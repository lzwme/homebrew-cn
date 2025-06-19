class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https:docs.mvt.reenlatest"
  url "https:files.pythonhosted.orgpackagesde2232aad49d0f07702a0cef255304a21f54d9958cb1628f192cf7332e3e4af1mvt-2.6.1.tar.gz"
  sha256 "dc13033369048752f4a9d06d579c9748237871d51e91a0d1dc76abb0e47f0a92"
  # Adaptation of MPL-2.0
  license :cannot_represent
  head "https:github.commvt-projectmvt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18e5b0cb9215344ff1bfc3152e1d13b0af57b22d02b96c5c5f4457fa76bd9c44"
    sha256 cellar: :any,                 arm64_sonoma:  "f560ddecb115f6af60a1ebf8f8539e9e7f5d16ccde4ba6fbbb42624cbbf2544f"
    sha256 cellar: :any,                 arm64_ventura: "37fbb149c3dc926cb3e73d7f3786389ccb618c95bd0b37d7196bf3be89603673"
    sha256 cellar: :any,                 sonoma:        "a0c7320f7d483a9cbd68c6845d644fbe2f5e277bfeff2ba0aad9fbbbf972b40c"
    sha256 cellar: :any,                 ventura:       "2288fcd8f64dc35ff1b11f6e8dd959dbc2608a7370948eec5973b459eb6bf552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5da706ca0fee18e90b93022d636203a26ea308069d065eca0e37f5b8b24e6ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1207a4ee3ef44f8701b40ab3d6c7d55fe10da489f1e1478284240a08867f9b68"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "adb-shell" do
    url "https:files.pythonhosted.orgpackages8f73d246034db6f3e374dad9a35ee3f61345a6b239d4febd2a41ab69df9936feadb_shell-0.4.4.tar.gz"
    sha256 "04c305f30a2ca25d5c54b3cd6ce9bb64c36e5f07967b23b3fb6aaecc851b90b6"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "betterproto" do
    url "https:files.pythonhosted.orgpackagesff2eabfed7a721928e14aeb900182ff695be474c4ee5f07ef0874cc5ecd5b0b1betterproto-1.2.5.tar.gz"
    sha256 "74a3ab34646054f674d236d1229ba8182dc2eae86feb249b8590ef496ce9803d"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "grpclib" do
    url "https:files.pythonhosted.orgpackages19750f0d3524b38b35e5cd07334b754aa9bd0570140ad982131b04ebfa3b0374grpclib-0.4.8.tar.gz"
    sha256 "d8823763780ef94fed8b2c562f7485cf0bbee15fc7d065a640673667f7719c9a"
  end

  resource "h2" do
    url "https:files.pythonhosted.orgpackages1b38d7f80fd13e6582fb8e0df8c9a653dcc02b03ca34f4d72f34869298c5baf8h2-4.2.0.tar.gz"
    sha256 "c8a52129695e88b1a0578d8d2cc6842bbd79128ac685463b887ee278126ad01f"
  end

  resource "hpack" do
    url "https:files.pythonhosted.orgpackages2c4871de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "hyperframe" do
    url "https:files.pythonhosted.orgpackages02e794f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
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

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "nskeyedunarchiver" do
    url "https:files.pythonhosted.orgpackagese8d9227a00737de97609b0b2d161905f03bb8e246df0498ec5735b83166eef8fNSKeyedUnArchiver-1.5.tar.gz"
    sha256 "eeda0480021817336e0ffeaca80377c1a8f08ecc5fc06be483b48c44bad414f4"
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

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf0868ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fbpydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackages671d42628a2c33e93f8e9acbde0d5d735fa0850f3e6a2f8cb1eb6c40b9a732acpydantic_settings-2.9.1.tar.gz"
    sha256 "c509bf79d27563add44e8446233359004ed85066cd096d8b510f715e6ef5d268"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages882c7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5bafpython_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
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

  resource "stringcase" do
    url "https:files.pythonhosted.orgpackagesf31f1241aa3d66e8dc1612427b17885f5fcd9c9ee3079fc0d28e9a3aeeb36fa3stringcase-1.2.0.tar.gz"
    sha256 "48a06980661908efe8d9d34eab2b6c13aefa2163b3ced26972902e3bdfd87008"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackagesdfa15723b07a70c1841a80afc9ac572fdf53488306848d844cd70519391b0d26tld-0.13.1.tar.gz"
    sha256 "75ec00936cbcf564f67361c41713363440b6c4ef0f0c1592b5b0fbe72c17a350"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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