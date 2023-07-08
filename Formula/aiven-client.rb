class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/61/b9/be0db76b6ab3d3b80af727ce502d17069cf9559b920e1cc0076d3ac9a03f/aiven_client-2.20.0.tar.gz"
  sha256 "b15f18afc3526d1facccea02d2f7362b1cd84a9a8a26be3023d972f3904423c5"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c0901e161dd97809caf3cd84cea98bf228b7e240162be415a20e4257f17057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c490f5dd9847bf700ec550bea2dd3fbecc48b01b00a1cf22dfb0f29f1a83e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82af0ee56d649af5baf54a51d99819f2dae9d3f62e29600e9ef14918673dd63"
    sha256 cellar: :any_skip_relocation, ventura:        "e58cc947f0a520eb7e12f3575a693b81193ed6115b248d3248ba84bcdba977a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8caab728f33bfbae539b084bbd7dc17a36a9b48757800a34cfba31b15c7c99b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2ca178c84c2b6285e845e121243f656d37104e8d0749a605e89a27eea3aa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27020f245ec2da7c355d00ab48d57c0e2961684d0f30a125e23867dbe46748be"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end