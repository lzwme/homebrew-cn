class Raven < Formula
  include Language::Python::Virtualenv

  desc "Risk Analysis and Vulnerability Enumeration for CICD"
  homepage "https:github.comCycodeLabsraven"
  url "https:files.pythonhosted.orgpackages63f44e41fcf000b9556a8e216dcf6d8d83f218a0914d89fdca47ee1e9bc13671raven-cycode-1.0.6.tar.gz"
  sha256 "e644e09194bcf2eadb9499d2e5b345250d7c494263397090ea87bb6d720015cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73364df83c0fb0e21b101336c6ff232039f9ef14dfe289b1a1995815d5ea2c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac36ac24bf260a9a5e71fd991e6bdc04312aae4bf6ffa577d19e6ce9f0407412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7707d016ecaa3c2bebbdf6e8da10367a7a8119665546b05da96bc60add7bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d478ecfd9c40167c9cbd91b7b80a27ec229defbefad07caa20dc7be5af74c782"
    sha256 cellar: :any_skip_relocation, ventura:        "089dfccdb1353f68a2b306bb43f8ec8ed487eb7a5e4adbacdc9c42aa4d6bad88"
    sha256 cellar: :any_skip_relocation, monterey:       "04ab70bc5b64d1d69044e290bfb9550174ae490bc6d16de4e42ec16bbb1ace7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f6962edef37103706e0ab1994591e3356477bf652c0e65cc56b758f59c1f51"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages2a53cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "interchange" do
    url "https:files.pythonhosted.orgpackagesca10055c9f411105acd277465a356f4d8c1c2a8d266b87ce68148c47ad54eebfinterchange-2021.0.4.tar.gz"
    sha256 "6791d1b34621e990035fe75d808523172340d80ade1b50412226820184199550"
  end

  resource "loguru" do
    url "https:files.pythonhosted.orgpackages9e30d87a423766b24db416a46e9335b9602b054a72b96a88a241f2b09b560fa8loguru-0.7.2.tar.gz"
    sha256 "e671a53522515f34fd406340ee968cb9ecafbc4b36c679da03c18fd8d0bd51ac"
  end

  resource "monotonic" do
    url "https:files.pythonhosted.orgpackageseaca8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86acmonotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "pansi" do
    url "https:files.pythonhosted.orgpackages220d2c19187e820cbad87e73619fe2450d2698eb003eb0a0137551bd687a9676pansi-2020.7.3.tar.gz"
    sha256 "bd182d504528f870601acb0282aded411ad00a0148427b0e53a12162f4e74dcf"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages365104defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "py2neo" do
    url "https:files.pythonhosted.orgpackages96bbfd298b06181fc4aace4838d91e6b511184ad1f3e5fe9cffee7878c66f14apy2neo-2021.2.4.tar.gz"
    sha256 "4b2737fcd9fd8d82b57e856de4eda005281c9cf0741c989e5252678f0503f77e"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackagese5d018209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "redis" do
    url "https:files.pythonhosted.orgpackages1db9b6eeedcbcf487b000f96aa085c842a46d24eab99a5bb05ba6fd917e0ea14redis-5.0.0.tar.gz"
    sha256 "5cea6c0d335c9a7332a460ed8729ceabb4d0c489c7285b0a86dbbf8a017bd120"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "slack-sdk" do
    url "https:files.pythonhosted.orgpackages0d3b1a9aefe8ce0f2b83d02059d3a69cc9fd9fb4f34a5629fdcebbc35456444cslack_sdk-3.22.0.tar.gz"
    sha256 "6eacce0fa4f8cfb4d84eac0d7d7e1b1926040a2df654ae86b94179bdf2bc4d8c"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "brewtest" do
      output = shell_output("#{bin}raven report 2>&1", 1)
      assert_match "[Errno 2] No such file or directory: 'library'", output

      output = shell_output("#{bin}raven report slack 2>&1", 2)
      assert_match "the following arguments are required: --slack-token-st, --channel-id-ci", output
    end
  end
end