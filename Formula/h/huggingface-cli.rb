class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/d5/31/4ae775122014855aa626043bf348a5473fb80ce6492ca57017930eda98d5/huggingface_hub-0.19.0.tar.gz"
  sha256 "7395c9b8053dc8aa0dec2900f367890f66be07bfe46369b95af3f4c1013eb09e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51867003bdf079c31a808944093ed9eb30fe485d1aaa7a3ec211af11caab1079"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3c9b224c7482c007822806d0b09b61846bf91acd773f1e4832179e9eb415816"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf56c004aac4cfadd2204cb24347ac6f4ea7923187a17e3a697cb6a50c32831"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e3b1c69c181f6e9d477b10cfb7252b1fc7e8aa150709c8e5eba2f022a77b662"
    sha256 cellar: :any_skip_relocation, ventura:        "b6fd03749cb9cb688ec4f18f77c1f0369096ffcb3bdbcfd2cb2c04f9aa1ba92e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ccb5e52786466250e3d8638380e3688715fd211d88ed4602b61cd11f387f605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b3c60cf8f028c35191e1c6be13d7a960161a0131557b59221881540fde5b923"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/a4/f7/16ec1f92523165d10301cfa8cb83df0356dbe615d4ca5ed611a16f53e09a/fsspec-2023.10.0.tar.gz"
    sha256 "330c66757591df346ad3091a53bd907e15348c2ba17d63fd54f5c39c4457d2a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end