class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https://github.com/ivan-sincek/forbidden"
  url "https://files.pythonhosted.org/packages/9b/aa/98fc3ee28aac41cae341a197858ff6af5d79e40dcd45c8a6e37b1fdbfd19/forbidden-13.4.tar.gz"
  sha256 "dc987150b71515810d7ae252895b3ca6e077a8d9b3cbb0d09dfc9797c933a14d"
  license "MIT"
  revision 6
  head "https://github.com/ivan-sincek/forbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a053ff9ff6118d41b2c92324fd3faf1fd98353e5fae38c0b5877e65e3f4b8079"
    sha256 cellar: :any,                 arm64_sequoia: "60065f76665acbdcf09b24e4bd3956597031bb83e88b3c272105409005d7bdb3"
    sha256 cellar: :any,                 arm64_sonoma:  "e5e25d7bd570465079a6f4b51f5c8848cd8644593f6c2e804dc76bf005e7fd64"
    sha256 cellar: :any,                 sonoma:        "bafddeaaa1b86ecea636c69eebefafd88976cdbb9cd84951743f23acde85ea4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9853c4edd77e4647e5833789dc5d57f02a26f3ab774650a60233f28c5511147c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0648987cb20ca107f5c818cec1f30d9edef10489095aaccf929e5cbce00a47c6"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pycparser" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cffi cryptography pycparser]

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/9a/26/d43128764a6f8fe1668c4f87aba6b1fe52bea81d05a35c84a70d3c70b6f7/alive-progress-3.3.0.tar.gz"
    sha256 "457dd2428b48dacd49854022a46448d236a48f1b7277874071c39395307e830c"
  end

  resource "bot-safe-agents" do
    url "https://files.pythonhosted.org/packages/12/67/b5659b1ad6d8fd4ba319f014e05a1c157ed5004bd82e30861919772426e7/bot_safe_agents-1.2.tar.gz"
    sha256 "d61bd82b69f56314ad45ad6bba7e044aac23c78659a552e4ae1482f17cb94eda"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "graphemeu" do
    url "https://files.pythonhosted.org/packages/76/20/d012f71e7d00e0d5bb25176b9a96c5313d0e30cf947153bfdfa78089f4bb/graphemeu-0.7.2.tar.gz"
    sha256 "42bbe373d7c146160f286cd5f76b1a8ad29172d7333ce10705c5cc282462a4f8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/95/23/cc07b16591af8ca373494d29aafc8df13e547077579e6779bb865a3f5a7f/pycurl-7.46.0.tar.gz"
    sha256 "422ed7005b98768fe60fe6b6cb8bb6a4e1fc18b5433402e8fbdaba91811c4604"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/46/79/cf31d7a93a8fdc6aa0fbb665be84426a8c5a557d9240b6239e9e11e35fc5/termcolor-3.3.0.tar.gz"
    sha256 "348871ca648ec6a9a983a13ab626c0acce02f515b9e1983332b17af7979521c5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/forbidden -u https://brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end