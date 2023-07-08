class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/38/a5/eac7345cff754bfe84933a99811d720e892671cccfcac5ac023f66efdc5f/huggingface_hub-0.16.4.tar.gz"
  sha256 "608c7d4f3d368b326d1747f91523dbd1f692871e8e2e7a4750314a2dd8b63e14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f167074739787fd016d792b27d7ba73976fe97c9bc18d2fa3a8d2a749df9740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ecba15fbef7afb1ea1f6c031bbc19bc4ecb190c4b4beee70324a8b86f7d438"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1096fe84de01e8e80e93f1e7c020d8eaa340a5456f199f6da3cc554e62df9900"
    sha256 cellar: :any_skip_relocation, ventura:        "c86ee1639fc862a8f5bc03e47aa482ce90768b030d0a8add5870b0060c1d9008"
    sha256 cellar: :any_skip_relocation, monterey:       "5624c23a1d7703326633c51044cdf6bd12ac62764861c389fa800015d7ea1735"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1bccfe204dede900c74789320ce88ab0ee7ec28fe98ad3422793f6cfb31796a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34436d7ecba96b6d3596cf5428fc143ff82c9392318f095cf92dd2c5b232a557"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/14/e4/33a5c4635cff37ef6eb66608c675ae678b48baa6e73b331536cf2cbf18a1/fsspec-2023.6.0.tar.gz"
    sha256 "d0b2f935446169753e7a5c5c55681c54ea91996cc67be93c39a154fb3a2742af"
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
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
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