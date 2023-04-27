class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/23/27/5c9adfa51fc841cd1e2c4949b49bd8f05ba4e8254ef5bb60ba82b8bcdafc/huggingface_hub-0.14.1.tar.gz"
  sha256 "9ab899af8e10922eac65e290d60ab956882ab0bf643e3d990b1394b6b47b7fbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba2fb4f11abd05e7ab2f0e189f96f5f982705adf125a10f1b04d85f086b5f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1752c1349b30bfc90e6ff40ddec946949ee359bd2485cde4752efa0a793bb57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebef02c9c4ce5545d2dc6a52a47a7d9e40135bb0fd2540fd4cf94eb6479178ff"
    sha256 cellar: :any_skip_relocation, ventura:        "4fd72ece6493561b0c7efc90ecc48ecfe2004c64f477aa3406970b55a0c3ba74"
    sha256 cellar: :any_skip_relocation, monterey:       "cf591ac69f185851688ccb2f01a91017a7dd540835a5538a57ee9c67211af136"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed9ddfccb0694f2e967cded8a0320f3450d04e35ee8c54dd3fffd8bc52ef4541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97207cf17d6c5023343e9ead3d3db923dab6a9fd067a86e236c9425b02222b5"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d8/c3/7eb5ace7aac24890fd6f3dbf49d547305237bd4002903f19b524061ce8ae/fsspec-2023.4.0.tar.gz"
    sha256 "bf064186cd8808f0b2f6517273339ba0a0c8fb1b7048991c28bc67f58b8b67cd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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