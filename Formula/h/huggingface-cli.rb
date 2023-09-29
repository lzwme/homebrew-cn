class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/13/d2/e0d36491422425bb882e4a6432a06aee9e56348aeefd9aab648a995d173b/huggingface_hub-0.17.3.tar.gz"
  sha256 "40439632b211311f788964602bf8b0d9d6b7a2314fba4e8d67b2ce3ecea0e3fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cdb83f818c659f814cdcf341e36e8029c6b87cb15fc8c24d253e1882468661c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7015694f34735026b2948e1a9668a3931803af3153df106aee4bc66b53ae0f40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ceb28c492ce67ba74926798c71161290c62ec88a38eed4b7e3a2578c7a517d"
    sha256 cellar: :any_skip_relocation, sonoma:         "79bda28546e36f671b2633eab78022f262debb7c83c268ee9f7966ba8fda2908"
    sha256 cellar: :any_skip_relocation, ventura:        "9f2f2b82c10244bab935e0350e42440a93b5ae835e4a8a948e69ce4d92763313"
    sha256 cellar: :any_skip_relocation, monterey:       "93e98f4bc454765d88b25b3247085f8a76661b630840f88c8e43cffa0efd71af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca60723b9c4a41423c65a51d50297ebc01746289cada8fe6d566f18f334fb9c"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/bd/c1/b9dbe600903f9ac2401e42f38cb376130485a6d0db611f60ab05fa8d21fc/fsspec-2023.9.2.tar.gz"
    sha256 "80bfb8c70cc27b2178cc62a935ecf242fc6e8c3fb801f9c571fc01b1e715ba7d"
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
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
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