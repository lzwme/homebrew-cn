class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/6d/43/0e8166583575bd500c0f8f1a4ab9429af9466feb6fcdc006e88de8fd23e9/howdoi-2.0.20.tar.gz"
  sha256 "51cd40c53e0c0f8f8da88f480eb7423183be2350ab4f0a4d9d4763ca6ac3e2a9"
  license "MIT"
  revision 21

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "071ee8a5741672efad90d41d5836681fb57a8bf93e22670bf9dedb21f6a94366"
    sha256 cellar: :any,                 arm64_sequoia: "4f128b71ebdbec1ed20d79efd8e83e9e0568e8aaab92d1f76db9d3c36e0cbf10"
    sha256 cellar: :any,                 arm64_sonoma:  "dfa6a1e5ebd04fa72c293b2219f8ff2ae7a1cacc0f8c7e16f287f2693dab8487"
    sha256 cellar: :any,                 sonoma:        "045660d075298c6bee3ffd274341813854672d3bf77dc60e4be431eb7222ed11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f8b7ac1d9845658359747677dc8588cefde897a918a4c6555f23b47b5693455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c15ecfd02c58b32d81462265a4859579aa28714368d0060f2f9da2ef0fa7637"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachelib" do
    url "https://files.pythonhosted.org/packages/66/a5/5eb041dbee71766704d44cf5dfb6950ab018be0fd02cd763ade09869e33c/cachelib-0.14.0.tar.gz"
    sha256 "73fedcadd0ba818fb2bb9f3c7cd5fcc2a71e86286f1842f55f28d500faee17f1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "keep" do
    url "https://files.pythonhosted.org/packages/60/2b/cff99a6e90eb54f88ea4f96395a788dce3167b95b5e2a93642f16d8a10e2/keep-2.11.tar.gz"
    sha256 "06bc2fbbf65ebebf2c384dca0306a40c3cd531cd95a05c486f5a2b5c07acd94d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/ab/c3/8465a311197e16cf5ab68789fe689535e90f6b61ab524cc32a39e67237ae/pygithub-2.9.1.tar.gz"
    sha256 "59771d7ff63d54d427be2e7d0dad2208dfffc2b0a045fec959263787739b611c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/ae/48/79e774ea00b671d08867f06d9258203be81834236c150ac00e942d8fc4db/pyquery-2.0.1.tar.gz"
    sha256 "0194bb2706b12d037db12c51928fe9ebb36b72d9e719565daba5a6c595322faf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "terminaltables3" do
    url "https://files.pythonhosted.org/packages/55/9b/9abd7feb0cf552061cfa452c22773f3158cdad877ad5623f13edfa07116f/terminaltables3-4.0.0.tar.gz"
    sha256 "4e3eefe209aa89005a0a34d1525739424569729ee29b5e64a8dd51c5ebdab77f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Here are a few popular howdoi commands ", shell_output("#{bin}/howdoi howdoi").split("\n").first
  end
end