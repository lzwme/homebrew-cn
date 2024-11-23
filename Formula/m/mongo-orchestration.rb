class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https:github.com10genmongo-orchestration"
  url "https:files.pythonhosted.orgpackages597cb1a9ed6bfedb7133c56d1253123ddea4d6396aac745f589f3e55fde1e27fmongo_orchestration-0.10.0.tar.gz"
  sha256 "c11126757e64c9ed08585a53bd95c0edb7fd0d8ca0861c13329c903936966f15"
  license "Apache-2.0"
  head "https:github.com10genmongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25bc059c11f4278be77b58aed7b436a4a67f22f283727ae0effd7feced1cab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "279cc710f34e644bc071f4886a9b78db5ba606594ec895f66a29af91cd2701cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ae506920b6d2237295bee49207ac8e6527f4aa68ecf0c19eed88370972fef01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dcf09fba57848009e2619c44f49908620dfa82bf336dbcdf926c162fd13bce8"
    sha256 cellar: :any_skip_relocation, ventura:       "c5aa61f592bc7e4df5f1f23e13c35367519ea8591b3a7cb4cf427c6dd39f2e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9538b4208c255994d76f2a0aa09a3fc7f36a136374fb314ef44c45f9740c6d19"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "bottle" do
    url "https:files.pythonhosted.orgpackages1bfb97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages63e2f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages517865922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178fmore-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "pymongo" do
    url "https:files.pythonhosted.orgpackages1a35b62a3139f908c68b69aac6a6a3f8cc146869de0a7929b994600e2c587c77pymongo-4.10.1.tar.gz"
    sha256 "a9de02be53b6bb98efe0b9eda84ffa1ec027fcb23a2de62c4f941d9a2f2f3330"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin"mongo-orchestration", "-h"
  end
end