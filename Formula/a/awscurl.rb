class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https:github.comokiganawscurl"
  url "https:files.pythonhosted.orgpackagesf05368500d2e61aff7549f878a9227eea5c80eaf6ffcad7c134c576360b1bae7awscurl-0.36.tar.gz"
  sha256 "9eb9d4949616d90dd7bf0d12a67eb3e1d3487bf08d75a7555d979811e5da1cb4"
  license "MIT"
  revision 1
  head "https:github.comokiganawscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30ab3e1f3198bc3b9cb38d37c3ba8dc847d352d03c8a7c9499a256b46f1dd25b"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9daa1521d7e1dcb76af8dca81539eec141ee3581a32e0dc1f31d092b59feb06abotocore-1.38.33.tar.gz"
    sha256 "dbe8fea9d0426c644c89ef2018ead886ccbcc22901a02b377b4e65ce1cb69a2b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages854d6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5dconfigargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages8bacea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match "Curl", shell_output("#{bin}awscurl --help")

    assert_match "The AWS Access Key Id you provided does not exist in our records.",
      shell_output("#{bin}awscurl --service s3 https:homebrew-test-non-existent-bucket.s3.amazonaws.com")
  end
end