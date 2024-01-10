class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/07/a7/de46c577512599e9baf8012f53a67f0688ba20b25bedbc521617b083c981/huggingface_hub-0.20.2.tar.gz"
  sha256 "215c5fceff631030c7a3d19ba7b588921c908b3f21eef31d160ebc245b200ff6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "238a24ad9978358366f7b0d0cf262c225155cac7f4755dbdf50dc6b9573eec3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e2b7c205b7b9f03ee373392a81b5ca39f9a2ced098857bd870b70aabc4e5524"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b62650fec3b9f4abf35816f8bb5fa54a8088f95950862a9bf03577860b9ed8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c367a88735565a666074de7d435d29bd1ebe9a22916eba373656954020197c33"
    sha256 cellar: :any_skip_relocation, ventura:        "960e5341d23776446af307f72b1bfd1cc1eec9924eaad27e9e1b2e85c5e406ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8d4099c311dafe82ca2c2eb3aa2fc2b829426d7354808370741d2bdd6e3bed60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81eac60154f6e8c1c5f272f87ca7973120d0e8d68a8553b9d3aaa7b4a82c5867"
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
    url "https://files.pythonhosted.org/packages/fa/08/cac914ff6ff46c4500fc4323a939dbe7a0f528cca04e7fd3e859611dea41/fsspec-2023.12.2.tar.gz"
    sha256 "8548d39e8810b59c38014934f6b31e57f40c1b20f911f4cc2b85389c7e9bf0cb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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