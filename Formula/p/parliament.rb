class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https:github.comduo-labsparliament"
  url "https:files.pythonhosted.orgpackagesa61292bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ceparliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  head "https:github.comduo-labsparliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9403346c9966ef7acf2569c4eb997136dc526a81b9579f455ac63620fe3c2da"
    sha256 cellar: :any,                 arm64_sonoma:  "9a65b166b6ccfca15fddf77d536eae03cd77902913cdba068c4eb09bc5551615"
    sha256 cellar: :any,                 arm64_ventura: "b3cc44cfbdfdcdbb07782df04b2c2be92f97d5fd237da1fe6b758b0e247fc9d4"
    sha256 cellar: :any,                 sonoma:        "47f8fb5e12e69fbcc66a96db6d13d68658121bb862bb0fa7521db1bdbdca6647"
    sha256 cellar: :any,                 ventura:       "6fd5021c681409134fbf7f4ff46bc32a3893446ba03f0754901d69ec28bb8652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4443335de6c820bfeb4f6664b11b7cf647cf4a0c6cc6742d004d5402839d5f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e903562d94d8918dfeeba821465831ec0d8462be17cd5e17d4cbbe950f83d44"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages61ced6fbf9cdda1b40023ef60507adc1de1d7ba0786dc73ddca59f4bed487e40boto3-1.38.3.tar.gz"
    sha256 "655d51abcd68a40a33c52dbaa2ca73fc63c746b894e2ae22ed8ddc1912ddd93f"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages92eeb47c0286ada750271897f5cc3e40b4405f1218ff392cd15df993893f0099botocore-1.38.3.tar.gz"
    sha256 "790f8f966201781f5fcf486d48b4492e9f734446bbf9d19ef8159d08be854243"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https:files.pythonhosted.orgpackages70d834e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https:files.pythonhosted.orgpackageseedaa7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesfc9e73b14aed38ee1f62cd30ab93cd0072dec7fb01f3033d116875ae3e7b8b44s3transfer-0.12.0.tar.gz"
    sha256 "8ac58bc1989a3fdb7c7f3ee0918a66b160d038a147c7b5db1500930a607e9a1c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesbb71b6365e6325b3290e14957b2c3a804a529968c77a049b2ed40c095f749707setuptools-79.0.1.tar.gz"
    sha256 "128ce7b8f33c3079fd1b067ecbb4051a66e8526e7b65f6cec075dfc650ddfa88"
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
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::**'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end