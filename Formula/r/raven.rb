class Raven < Formula
  include Language::Python::Virtualenv

  desc "Risk Analysis and Vulnerability Enumeration for CI/CD"
  homepage "https://github.com/CycodeLabs/raven"
  url "https://ghproxy.com/https://github.com/CycodeLabs/raven/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "35bb528c902909acb5793243d1a865c22c35ac3fec81624b4aabf2de2304ffae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91218b6ec7d2e1768a545bdc1e10b55290935f9761c5fbaa14650fd02eb94184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "150f177a30ec93fe89c6d99d7e4f0eed72e7c3b9aa7f0f8e4ac950f8cfa642d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa61987edd0037c373c45889d5ccb12fc6e1e924dec1c3c469473a686ca27db"
    sha256 cellar: :any_skip_relocation, sonoma:         "2637b8a3b3a0cc40526f9f9aae2652f9e836e8c7060380bb621cac3cf5a54721"
    sha256 cellar: :any_skip_relocation, ventura:        "993b9cff0d7bc4aaaedf2339273132b482094739b5fdffb1fbd4e301ea36b56b"
    sha256 cellar: :any_skip_relocation, monterey:       "0299c585d8854aa99f94efdf2622385f56650ba6ec0c8ea66d2fe3eda09d3cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460c1079fe63b77cb0c3d0afe684e3fb556bd5c207c033c7076e3dc497b0f369"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "interchange" do
    url "https://files.pythonhosted.org/packages/ca/10/055c9f411105acd277465a356f4d8c1c2a8d266b87ce68148c47ad54eebf/interchange-2021.0.4.tar.gz"
    sha256 "6791d1b34621e990035fe75d808523172340d80ade1b50412226820184199550"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/9e/30/d87a423766b24db416a46e9335b9602b054a72b96a88a241f2b09b560fa8/loguru-0.7.2.tar.gz"
    sha256 "e671a53522515f34fd406340ee968cb9ecafbc4b36c679da03c18fd8d0bd51ac"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "pansi" do
    url "https://files.pythonhosted.org/packages/22/0d/2c19187e820cbad87e73619fe2450d2698eb003eb0a0137551bd687a9676/pansi-2020.7.3.tar.gz"
    sha256 "bd182d504528f870601acb0282aded411ad00a0148427b0e53a12162f4e74dcf"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "py2neo" do
    url "https://files.pythonhosted.org/packages/96/bb/fd298b06181fc4aace4838d91e6b511184ad1f3e5fe9cffee7878c66f14a/py2neo-2021.2.4.tar.gz"
    sha256 "4b2737fcd9fd8d82b57e856de4eda005281c9cf0741c989e5252678f0503f77e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/1d/b9/b6eeedcbcf487b000f96aa085c842a46d24eab99a5bb05ba6fd917e0ea14/redis-5.0.0.tar.gz"
    sha256 "5cea6c0d335c9a7332a460ed8729ceabb4d0c489c7285b0a86dbbf8a017bd120"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/0d/3b/1a9aefe8ce0f2b83d02059d3a69cc9fd9fb4f34a5629fdcebbc35456444c/slack_sdk-3.22.0.tar.gz"
    sha256 "6eacce0fa4f8cfb4d84eac0d7d7e1b1926040a2df654ae86b94179bdf2bc4d8c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "brewtest" do
      output = shell_output("#{bin}/raven report 2>&1", 1)
      assert_match "[Errno 2] No such file or directory: 'library'", output

      output = shell_output("#{bin}/raven report slack 2>&1", 2)
      assert_match "the following arguments are required: --slack-token/-st, --channel-id/-ci", output
    end
  end
end