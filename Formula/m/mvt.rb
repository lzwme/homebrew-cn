class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https://docs.mvt.re/en/latest/"
  url "https://files.pythonhosted.org/packages/de/22/32aad49d0f07702a0cef255304a21f54d9958cb1628f192cf7332e3e4af1/mvt-2.6.1.tar.gz"
  sha256 "dc13033369048752f4a9d06d579c9748237871d51e91a0d1dc76abb0e47f0a92"
  # Adaptation of MPL-2.0
  license :cannot_represent
  revision 1
  head "https://github.com/mvt-project/mvt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70a53f49c074e202bf4f326d31efdb6efb20b6ded0004b22006634ed0fcc063f"
    sha256 cellar: :any,                 arm64_sonoma:  "b8ff7ee0cf7fe86546703d6f8b88c8f69ff334148fcde15928ed0e5e70d9fcd7"
    sha256 cellar: :any,                 arm64_ventura: "5912ce750d445d2eda02eab6543117afe5c4ca541727edde6ea0dda61b79ec2b"
    sha256 cellar: :any,                 sonoma:        "3f6593c04c01a0ba9d4cd10da7bc6988c09d06f0cbfb8b9932bb2fca15836dbc"
    sha256 cellar: :any,                 ventura:       "715eaa5446232033528a4aeb0de064353277dc36476e430b458c00e480968731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4fa983d3965a3eec11e7334be5a27debd89414be76cacde4b7bbc16001ee5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47818cd1ce919b00f0f18546c0a12923a62230cb8134571eac29aed59f1f3191"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "adb-shell" do
    url "https://files.pythonhosted.org/packages/8f/73/d246034db6f3e374dad9a35ee3f61345a6b239d4febd2a41ab69df9936fe/adb_shell-0.4.4.tar.gz"
    sha256 "04c305f30a2ca25d5c54b3cd6ce9bb64c36e5f07967b23b3fb6aaecc851b90b6"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "betterproto" do
    url "https://files.pythonhosted.org/packages/ff/2e/abfed7a721928e14aeb900182ff695be474c4ee5f07ef0874cc5ecd5b0b1/betterproto-1.2.5.tar.gz"
    sha256 "74a3ab34646054f674d236d1229ba8182dc2eae86feb249b8590ef496ce9803d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "grpclib" do
    url "https://files.pythonhosted.org/packages/19/75/0f0d3524b38b35e5cd07334b754aa9bd0570140ad982131b04ebfa3b0374/grpclib-0.4.8.tar.gz"
    sha256 "d8823763780ef94fed8b2c562f7485cf0bbee15fc7d065a640673667f7719c9a"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iosbackup" do
    url "https://files.pythonhosted.org/packages/db/b8/4cd52322deceb942b9e18b127d45d112c2f7a3ec7821ab528659d4f04275/iOSbackup-0.9.925.tar.gz"
    sha256 "33545a9249e5b3faaadf1ee782fe6bdfcdb70fae0defba1acee336a65f93d1ca"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/a2/7f/c59ad56d1bca8fa4321d1bb77ba4687775751a4deceec14943a44da18ca0/libusb1-3.3.1.tar.gz"
    sha256 "3951d360f2daf0e0eacf839e15d2d1d2f4f5e7830231eb3188eeffef2dd17bad"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/69/7f/0652e6ed47ab288e3756ea9c0df8b14950781184d4bd7883f4d87dd41245/multidict-6.6.4.tar.gz"
    sha256 "d2d4e4787672911b48350df02ed3fa3fffdc2f2e8ca06dd6afdf34189b76a9dd"
  end

  resource "nskeyedunarchiver" do
    url "https://files.pythonhosted.org/packages/e8/d9/227a00737de97609b0b2d161905f03bb8e246df0498ec5735b83166eef8f/NSKeyedUnArchiver-1.5.tar.gz"
    sha256 "eeda0480021817336e0ffeaca80377c1a8f08ecc5fc06be483b48c44bad414f4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyahocorasick" do
    url "https://files.pythonhosted.org/packages/06/2e/075c667c27ecf2c3ed6bf3c62649625cf1e7de7fd349f63b49b794460b71/pyahocorasick-2.1.0.tar.gz"
    sha256 "4df4845c1149e9fa4aa33f0f0aa35f5a42957a43a3d6e447c9b44e679e2672ea"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f0/86/8ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fb/pydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/67/1d/42628a2c33e93f8e9acbde0d5d735fa0850f3e6a2f8cb1eb6c40b9a732ac/pydantic_settings-2.9.1.tar.gz"
    sha256 "c509bf79d27563add44e8446233359004ed85066cd096d8b510f715e6ef5d268"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/af/92/51b417685abd96b31308b61b9acce7ec50d8e1de8fbc39a7fd4962c60689/simplejson-3.20.1.tar.gz"
    sha256 "e64139b4ec4f1f24c142ff7dcafe55a22b811a74d86d66560c8815687143037d"
  end

  resource "stringcase" do
    url "https://files.pythonhosted.org/packages/f3/1f/1241aa3d66e8dc1612427b17885f5fcd9c9ee3079fc0d28e9a3aeeb36fa3/stringcase-1.2.0.tar.gz"
    sha256 "48a06980661908efe8d9d34eab2b6c13aefa2163b3ced26972902e3bdfd87008"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/df/a1/5723b07a70c1841a80afc9ac572fdf53488306848d844cd70519391b0d26/tld-0.13.1.tar.gz"
    sha256 "75ec00936cbcf564f67361c41713363440b6c4ef0f0c1592b5b0fbe72c17a350"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    venv = virtualenv_install_with_resources without: "iosbackup"

    # iosbackup is incompatible with build isolation: https://github.com/avibrazil/iOSbackup/pull/32
    resource("iosbackup").stage do
      inreplace "setup.py", "from iOSbackup import __version__", "__version__ = '#{resource("iosbackup").version}'"
      venv.pip_install Pathname.pwd
    end

    %w[mvt-android mvt-ios].each do |script|
      generate_completions_from_executable(bin/script, shell_parameter_format: :click)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mvt-android version")
    assert_match version.to_s, shell_output("#{bin}/mvt-ios version")

    outputandroid = shell_output("#{bin}/mvt-android download-iocs")
    outputios = shell_output("#{bin}/mvt-ios download-iocs")

    assert_match "[mvt.common.updates] Downloaded indicators", outputandroid
    assert_match "[mvt.common.updates] Downloaded indicators", outputios
  end
end