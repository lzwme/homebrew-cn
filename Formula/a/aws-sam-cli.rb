class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/01/ad/fe5882462e812f57a55c8f2eb5182420dbb3eab633d2bc9486372f169967/aws-sam-cli-1.106.0.tar.gz"
  sha256 "885c7a81a8cab23b798c98cb3a4362ae189b7a55507d560d4fb2cbdf244a2bc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "474cd18c9cd104e33b05cfb9bd85e154d5850a7ed90bfbbc99d158270fa23b1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96dd0ebb0300fbe2720a697aefe9516cc193a32c0feea6ecd08c55cf05273adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be5ac22e67a278c188552dadf7dd468229a47921d40a584905e715fe324f1fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "257b73cac30de8ac3b8faccf6061ec9947fd271fad278409df152f2420d57b9a"
    sha256 cellar: :any_skip_relocation, ventura:        "f2f9f51abe18491d7c4fed5eb2ddc7655637f1a2cb1bfc25f08ab19d695aba5a"
    sha256 cellar: :any_skip_relocation, monterey:       "0a92f85b1ea0ab18ba06adb3dd55d44f572bc4d5ecd07d30aa0bc1076b04cc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001f828a27ae8068760b48aeb16081a9c7487e1b3519a022d7e9170f3bce7e21"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "cfn-lint"
  depends_on "cookiecutter"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-networkx"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/88/0c/13b2dd06cd206822e7be2f0acd86e3561d1991f20cf5d3aebc1210f31e90/aws_lambda_builders-1.45.0.tar.gz"
    sha256 "5c19a6628eecf21578cd9c521e747f4a2163c62c527cd840b11b62a10b661348"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/52/a9/e927da123fb47a00cd3d7255ebb41ac1a9a0317a111709926f74de3afef1/boto3-stubs-1.34.9.tar.gz"
    sha256 "41220432e898a7a3fa60bb52ef2d49c864f5b38e2baa6a6235f57387325a242e"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/e5/b1/051770581dab9810511d1bf42e613580f0a12306c585393669c044ffc493/botocore_stubs-1.34.12.tar.gz"
    sha256 "bc0caf41c0e05464ea74a8c502d8e5e16761a2f9975ff598483b87c4c1d7f253"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "mypy-boto3-apigateway" do
    url "https://files.pythonhosted.org/packages/04/69/6b2bb7857de854b085301802891856ff47617ed22793ecf79675aff9589a/mypy-boto3-apigateway-1.34.0.tar.gz"
    sha256 "3c724120971c74fb65a94eb7e4b92a3a4b28df6c70ca04a007072e6c73f6eda7"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/6c/0c/7daa63b493b2b350fa3ec5b994ed74abe5015d08c5e352e6c7efbabd739b/mypy-boto3-cloudformation-1.34.0.tar.gz"
    sha256 "9b25df9ef15d9dc8e4e892cc07aa9343f15f2ed5eb7d33eb5eb65adfa63f538f"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/52/05/3cb67f373c30340e0043d5d8f5f07a163e263a691b3254ce361c2c9090cd/mypy-boto3-ecr-1.34.0.tar.gz"
    sha256 "b83fb0311e968a42d4ca821b006c18d4a3e3e364b8cebee758ea4fa97c5ac345"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/a6/ae/32dfd261793efc74a41898b6c6eb23078a1f648aae484a44d4225662ef84/mypy-boto3-iam-1.34.8.tar.gz"
    sha256 "6faf68cf800182924687b6711b3f9afa8d940ad993f259a3b91e55e82892d641"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7d/14/fd707a18485ebf99ac10388b3f1bd2a40f49c8f04dbcd1e2aa86cc7991f9/mypy-boto3-kinesis-1.34.0.tar.gz"
    sha256 "f404e75badd5977e9f09741b769b8888854bdd411c631344686ab889efe98741"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/e0/5d/c3ab6ebbd20c34e877f81fcf6e5a05bdecb13a799fb185f8c28dd9a110f6/mypy-boto3-lambda-1.34.0.tar.gz"
    sha256 "e74c0ce548da747a8c6e643c39dad8aa54d67e057f57740ec780a7e565590627"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/10/67/821fb516d4c151a7a18e660b780e883d1cd440b7077ca481704387799ac7/mypy-boto3-s3-1.34.0.tar.gz"
    sha256 "7644a00e096ebb1c3292551059f64ff8329625dacd40827ced9481b14d64c733"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/0b/7e/1850db88a985b7b044ab3c49e2cb5f2cebd531f01f228b86504cdffedef7/mypy-boto3-schemas-1.34.0.tar.gz"
    sha256 "3b25a71944192b0980c3bb5132deb7c06ee9b88580ed63f257fad97cf3bf2927"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/2f/07/3f0c04db35f742cc0f8a783dfb9f4dc85c9f12411f459159b57c8d48d255/mypy-boto3-secretsmanager-1.34.7.tar.gz"
    sha256 "0dcd72d7e6d2657838819b078447adc13199e35d8dee960e7fbe6c0e5d383b6b"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/ea/69/7c5455482360efb2705f0253c2f7e5069ac4a0bc3038280eb2336409e25e/mypy-boto3-signer-1.34.0.tar.gz"
    sha256 "c11ed943ccd38ee54fc0ca90ed347ef770d695df49535eab96dd97fb3dbdc592"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/f7/79/d70757f58c90c1d530023e18bc45b33eb6fa4435121c965f8921c4bc1ca5/mypy-boto3-sqs-1.34.0.tar.gz"
    sha256 "0bf8995f58919ab295398100e72eaa7da898adcfd9d339a42f3c48ce473419d5"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/8d/95/857d5b47f42815c95d4bc118e5c1b5decad44a169b1766f07c6233724326/mypy-boto3-stepfunctions-1.34.0.tar.gz"
    sha256 "06d2296cee750d17cb62171420eea4614f20f29be45ee361854f8b599a6e8110"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/cc/73/e93911b3451f252f375967b77f816719bef549488293918c3a4a7b0afd54/mypy-boto3-sts-1.34.0.tar.gz"
    sha256 "b347e0a336d60162dd94074d9d10f614f2b09a455c9b42415850d54d676e2067"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/eb/46/c35eddcbfb026f46e7ad0d934c888f45401bd51844c5edaecdb3d5a5b1b3/mypy-boto3-xray-1.34.0.tar.gz"
    sha256 "f30785798022b7f0c114e851790af9b92cb4026ed28757e962d30fb4391af8e2"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/4b/20/6fee0c1ef4445f020a61cf71ef3a71da7634c58b4ded2b0564bfe5bb2b1a/types_awscrt-0.20.0.tar.gz"
    sha256 "99778c952e1eae10cc7a53468413001177026c9434345bf00120bb2ea5b79109"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/5b/90/f00658473474581f334c43993f3cfd518955d4eb125cffa1279c94cf1605/types_s3transfer-0.10.0.tar.gz"
    sha256 "35e4998c25df7f8985ad69dedc8e4860e8af3b43b7615e940d53c00d413bdc69"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[cfn-lint cookiecutter].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end