class EcsDeploy < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to simplify Amazon ECS deployments, rollbacks & scaling"
  homepage "https:github.comfabfuelecs-deploy"
  url "https:files.pythonhosted.orgpackages8dd6bc7539a7ce66064e81ffdf2ccb87083d01d0d801550b5d1dffcebfa273e6ecs-deploy-1.15.1.tar.gz"
  sha256 "19b476f8874c1eebda32be58fd28420b3ab4a2867a69bff683f4c68a09a0a0c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87b891d72d228bbeade79cd5ec987a7d29def9b0797e49375221e589a898c5af"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesc20343244d4c6b67f34a979d2805ebb4f63c29b9aef3683ad179470fea52a5f3boto3-1.37.19.tar.gz"
    sha256 "c69c90500f18fd72d782d1612170b7d3db9a98ed51a4da3bebe38e693497ebf8"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackagesa54acf22a677045a02cf769d8126ce25572695508e4bd5d7f6fe984dc5d23c76botocore-1.37.19.tar.gz"
    sha256 "eadcdc37de09df25cf1e62e8106660c61f60a68e984acfc1a8d43fb6267e53b8"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages22443d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "dictdiffer" do
    url "https:files.pythonhosted.orgpackages617b35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
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
    url "https:files.pythonhosted.orgpackages4cd270fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdbrequests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages0fecaa1a215e5c126fe5decbee2e107468f51d9ce190b9763cb649f76bb45938s3transfer-0.11.4.tar.gz"
    sha256 "559f161658e1cf0a911f45940552c696735f5c74e64362e515f333ebed87d679"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese4e86ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392furllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"ecs", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    ENV["AWS_DEFAULT_REGION"] = "us-east-1"

    output = shell_output("#{bin}ecs run TEST_CLUSTER TEST_TASK 2>&1", 1)
    assert_match "Unknown task definition arn: TEST_TASK", output

    assert_match version.to_s, shell_output("#{bin}ecs --version")
  end
end