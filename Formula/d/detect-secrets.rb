class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 2
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07042dbc4265092748e4064f5943df0452230afe480a2c5be1276e2e11f13396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "959e1b013175920947e98c7b51cd40df7142a1a47415a0336c4ffe276bfd0f15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a87c9422e5baad526c76035566c6c03eae0c10d9f4df71f304c71b870e86d71f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf95aaf408cd07a0e48a6975c8be9d3994d8336bd0109368d4b1eca4ed25a6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "1c0c9c84816de1ea5a031082d7db456d6809d151ce5fbb20f588662d49548044"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8a305098e17366475731555a8924319934389a409d8150219533f013381b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef53b96cd445545418d73c6b84551c74f9497a3cbbbe97323c0973ebe2cee90e"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end