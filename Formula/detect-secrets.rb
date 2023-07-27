class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae1baf1a50e5326ff7fad1c65bf676ce7220bd9b0d963caf75bc704549b26dc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "042483d111100dfa5d6ffeaa4150cb6c691dcaa92a06d912c9d04942d5616c5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f2860e4aed47ee187d5c604e4238cf66c3474d9d360ac01d03fc10c4c47ed3f"
    sha256 cellar: :any_skip_relocation, ventura:        "171f9ece0a2f356a03398b6ea139e7702779a6e59d72050dfdbbad41b0b5dd27"
    sha256 cellar: :any_skip_relocation, monterey:       "69abb32770b1ba23895f23276cfe22168af1a71655258d8820055666be0a00df"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d00bb3b835354611005e959182dc49a08ad4a2da73b01eb210489f0144530e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3140760c912b7004174b7c4fd6134728e9ef13d85dfb9680bfa5f378aa854e7c"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end