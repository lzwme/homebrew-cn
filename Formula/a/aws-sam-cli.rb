class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/43/32/3a3be0d87cf19f9c5d388740207df688237a1983be639e6561e6671a3e07/aws-sam-cli-1.103.0.tar.gz"
  sha256 "3a8add61f5817413dd507563e1719b3f0c0bb89c5b357f6ae31613612bc67d71"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "063ce3be37cbe2b84a1100c6e0556c842e78aa369faaba2a0b1d7c76ff055509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83993899e3136a9b5d7a8fca3b282345ce16852e666e654f46e7ee910238b885"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cb2a165854da9d97569067abf3ea7190e2d906d04be9df3939074ad9b64762"
    sha256 cellar: :any_skip_relocation, sonoma:         "0292f6ca49a2dec89e1343d866cf6154d9e9d1418d5614424be4f4de08e4d520"
    sha256 cellar: :any_skip_relocation, ventura:        "9486ee3dd2bb233231be1c5f67b95a9e1b678d65a44c2f7cfcf030efea39d44e"
    sha256 cellar: :any_skip_relocation, monterey:       "cec0529efa84cb3b2a58dc7e1fd8740c57c1bbbcc5e4fd08fe238024a2abe813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a763c75ee2426d192a3f39c413d4c4f960f810138193af68eaa08791ba4e0a6"
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
    url "https://files.pythonhosted.org/packages/31/4c/2efb926abdd38ab6768e9eb1e6877b0bbc5889ff542d116fb81f8fee426c/aws_lambda_builders-1.42.0.tar.gz"
    sha256 "c0d3c4e1d9d663ccc9d13470487958fd4cc0918610786a454759b8d383a10043"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/66/e7/85c261c667c2931669e47cb5746253b0acdcf8a360b532754f41d3a53796/boto3-stubs-1.29.0.tar.gz"
    sha256 "897cb22cbf7971809cac10470121ac194a5cc57d5fb3d8bfec09e07b3cb7646b"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/52/15/5116ffef61051b558cbad0fb75769f0628952b6ccd53ffd23cc193350c51/botocore_stubs-1.32.6.tar.gz"
    sha256 "5292a75cb0218be7099fcfc57bde1eea7853b7ece15984b22ed3bd9439247fcd"
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
    url "https://files.pythonhosted.org/packages/b0/a2/808a9af3d81c173f13e846c71462b967e3a77c9f1f5e1be315ea7521a50f/mypy-boto3-apigateway-1.29.0.tar.gz"
    sha256 "2f905563c4b96c2e22e6cbaa2f85cf732d405ac4d60b6c6c70675bea717f895a"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/e0/a6/87b654db9f1d5000b86b2ab1f2e847c8e7107730684d9301a62965378b43/mypy-boto3-cloudformation-1.29.3.tar.gz"
    sha256 "97de6aa92ce09783e5d58c97f417f5af5de659ef415b7c11ec202cea85c2d6c7"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/52/dc/27837109ba55fe163d24b3b1afe4117d8eb3371b72305d96fcab24154432/mypy-boto3-ecr-1.29.3.tar.gz"
    sha256 "b98cc486a7550f699fb43f3477a0f48923d0edff38c5ced839f5dc4029076985"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/9d/bd/0bec6c061395daad64e855e9d9a3be4203cdd22747bb28f3e9d4eb306db8/mypy-boto3-iam-1.29.0.tar.gz"
    sha256 "26b617b134ed0a1011b0ccc7e94792899591f19ae2f0e9305789a0d1c7f5a427"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/54/f3/92adbb324f82e0db5f2a64235001e840644248a17355e67c7d30aed6b526/mypy-boto3-kinesis-1.29.6.tar.gz"
    sha256 "ccd6bb018e248d16d83a5c88164cb6f2e4a9438d99b1d160d490f345bd217304"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/48/ef/7336d64389cfccd176ff13f5a071f2062963030e8d17fa9162926a88a8bf/mypy-boto3-lambda-1.29.2.tar.gz"
    sha256 "ef91beb5c3b0e46b2d57f95454c940673ed4fd35a56bdaaafdf0ef0b1cfd662d"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/0b/f6/546a0aee4bfefa538b490a5b73a9161516e34f94b8610b18aa748c79ded7/mypy-boto3-s3-1.29.5.tar.gz"
    sha256 "82c9df70b6cfa5e1c3e208a63aaa6edda4fc80696c8718fda4e6ed5bb6501ad3"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/7d/db/c1bda15c0a360f735fc8754057792d092c29ca7a7b6c30271d27a3ca9ded/mypy-boto3-schemas-1.29.0.tar.gz"
    sha256 "590fe23c13a2fa129f25e8b37285061d6264f4aed53ac26fcbcf1aace29775b4"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/87/74/174cf4d4cfa3bc2852728bd8bd51b5527b62283f5060265d8da39eb2b4f0/mypy-boto3-secretsmanager-1.29.0.tar.gz"
    sha256 "2cd901588b54425825884a515bd48937d77f3aaa67acc1a0dfaae8d00a015eca"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/3a/7b/52e7ec51aed0dcdefd3fc34319cb4087064e207115ced315c3603a8fe116/mypy-boto3-signer-1.29.0.tar.gz"
    sha256 "fee1b7eda26be4b59fb1d4d880f42f7d35a19d1685c46dbf19faaab65ac168f0"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/db/c1/67f8535650fd7cf6e696797bc0723aaa4d22d8d6d3600e14841efed9427e/mypy-boto3-sqs-1.29.0.tar.gz"
    sha256 "0835256e3aabd27b2acf613c1b82a22b9de18412a0b07bd04d6d214c3f063906"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/91/67/6d1708d50ee2243c8b8d17409da341d7f235be86f5fb5d8511dc08e615fe/mypy-boto3-stepfunctions-1.29.0.tar.gz"
    sha256 "3c87706c229b9e57298362dda4b3b920ac5fafcf304ce565f76179abbb222275"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/e6/b4/549dad7156ffa7831f6c8aea429bb6a1cad20564d5b81c4ed62ab11d9a27/mypy-boto3-sts-1.29.3.tar.gz"
    sha256 "07f384710303c6b3e4fdf5a8b617c73b3e449e85113efd957be2fd1d7f2b8e40"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/83/04/ea4b2db6bd364f2faa230f9122713e737e4639cd6d68c1ca5d754dc8fe0e/mypy-boto3-xray-1.29.0.tar.gz"
    sha256 "ddc37e681d73c56f88268eff13d98572888ab4ea10430af7d181b39f3aca40f7"
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
    url "https://files.pythonhosted.org/packages/9b/93/93f12cdd3b9da81e94f2435d01fe6b3e9edc7704a25d4ad260ce7906ca62/tomlkit-0.12.2.tar.gz"
    sha256 "df32fab589a81f0d7dc525a4267b6d7a64ee99619cbd1eeb0fae32c1dd426977"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/a7/47/61af579a7d901259c3ac064fb547cd619494720482aeea1880398b75146a/types_awscrt-0.19.13.tar.gz"
    sha256 "3747ab27193414de3b202952b746224981f9f23f72b1016c7124a137bac00f7b"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/d0/7f/bcb4025a389d53d1cfc9d592d710bff173ac98945ac28c67b58bd98089fe/types_s3transfer-0.7.0.tar.gz"
    sha256 "aca0f2486d0a3a5037cd5b8f3e20a4522a29579a8dd183281ff0aa1c4e2c8aa7"
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
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
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