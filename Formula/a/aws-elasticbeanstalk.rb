class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https:docs.aws.amazon.comelasticbeanstalklatestdgeb-cli3.html"
  url "https:files.pythonhosted.orgpackagesec5e96dbeec0f796ac7928f52ed61c6b3a44764ae4113185bb1e08fc4d758ba7awsebcli-3.20.10.tar.gz"
  sha256 "8599d0e2ca70e42ee55948e6f58f65ea06596143c556925572fbf80ce705548d"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07520a8c2b0281262c0cadea682ebc49f51cc8e872bb80fef15e83c2a8d31343"
    sha256 cellar: :any,                 arm64_ventura:  "87536e23e8cc00ed743b04185dfd83d83c67be206f98479281a4ca891ed42873"
    sha256 cellar: :any,                 arm64_monterey: "5f926df65a94e2ea92b1e01482edc9102bb4f4432bb099fdf066915502089632"
    sha256 cellar: :any,                 sonoma:         "c120c9d6f0e924caa75a3ab89ca5f0b763475007d75108300cff6561915d0062"
    sha256 cellar: :any,                 ventura:        "5638daab3e0081c5a6d0c95144a8ecc450f9caf37192951c983aa728f61c1565"
    sha256 cellar: :any,                 monterey:       "38b19c4431ee77ed75645b8895f72ea4e6454528189f6fe0160268f50bcd91d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79a865b9940436a29f4e93853d2484c535d6944c5b6e4b378b7d71cc4997dfb"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.11" # Python 3.12 needs https:github.comawsaws-elastic-beanstalk-clipull512

  uses_from_macos "libffi"

  resource "blessed" do
    url "https:files.pythonhosted.orgpackages25ae92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages98ab5d42fe78dd88c65c9dea758c7384c8a040bb40ef34f6483dd424807e1641botocore-1.31.85.tar.gz"
    sha256 "ce58e688222df73ec5691f934be1a2122a52c9d11d3037b586b3fff16ed6d25f"
  end

  resource "cement" do
    url "https:files.pythonhosted.orgpackages7060608f0b8975f4ee7deaaaa7052210d095e0b96e7cd3becdeede9bd13674a1cement-2.8.2.tar.gz"
    sha256 "8765ed052c061d74e4d0189addc33d268de544ca219b259d797741f725e422d2"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackages8275f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12dcolorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackages249fa9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackagesd4523be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages8a48a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages259d0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}eb init --region=us-east-1 --profile=homebrew-test", 4)
    assert_match("ERROR: InvalidProfileError - The config profile (homebrew-test) could not be found", output)
  end
end