class EcsDeploy < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to simplify Amazon ECS deployments, rollbacks & scaling"
  homepage "https:github.comfabfuelecs-deploy"
  url "https:files.pythonhosted.orgpackages17919febc5c9ee79719d3fc02bc70c2d5009192e6e886faf99525aa9eccc2d37ecs-deploy-1.14.0.tar.gz"
  sha256 "70e37b28da0496d8f2c50d998945ec4f1844ff1b4d6d119db7f1810bf4916127"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c34b3f0d4a0658da6c70e9e98df4a8c00583da6f75b00e522d66c3802eacec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c34b3f0d4a0658da6c70e9e98df4a8c00583da6f75b00e522d66c3802eacec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1c34b3f0d4a0658da6c70e9e98df4a8c00583da6f75b00e522d66c3802eacec"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d6cfae65b6db404027729ae3d1cd5f81a5f2462a047dbb3c6384805df0e013e"
    sha256 cellar: :any_skip_relocation, ventura:        "3d6cfae65b6db404027729ae3d1cd5f81a5f2462a047dbb3c6384805df0e013e"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6cfae65b6db404027729ae3d1cd5f81a5f2462a047dbb3c6384805df0e013e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d484e2c629d2ddbc81015c0d808d554ab0af859ae39f2c4d1c4459a48427a3"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages1ab5679e002118ac9dff4ee6411505b596556eaa4124eaccbb583d0a16174851boto3-1.34.130.tar.gz"
    sha256 "b781d267dd5e7583966e05697f6bd45e2f46c01dc619ba0860b042963ee69296"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages4ba889d45112f862992e4ecf1cbc776111761654694b2cf5c080c2ed79ec864cbotocore-1.34.130.tar.gz"
    sha256 "a242b3b0a836b14f308a309565cd63e88654cec238f9b73abbbd3c0526db4c81"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages22443d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "dictdiffer" do
    url "https:files.pythonhosted.orgpackagesbaedcee2a41eefad60860a8b64513d2be7b15cbc5a4e3ecaa4c9921b11732629dictdiffer-0.8.0.tar.gz"
    sha256 "b3ad476fc9cca60302b52c50e1839342d2092aeaba586d69cbf9249f87f52463"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages1c1c8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
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