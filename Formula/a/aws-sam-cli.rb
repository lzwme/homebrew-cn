class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/c5/ce/9ddcdfe18466ec6a7eac5b157d37f377a6c3c8ee331a0c0434a8ac0472cb/aws-sam-cli-1.109.0.tar.gz"
  sha256 "2853a836b66c16d4a0c6c8312c2300e8c298fc76d4ff9917955c963d158bffcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d15ecaf606a5babadcd7352bb21f5589d5877770b5f6fed8af555ce915878c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a626ba15b4fa1b430cafb8ec4596d96707b74addc662cbde96ae12c8d6e61ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e960f23bc9c11b3c91a740a98ef5045cd3a7f2efdbbfa6f37018556d565dbd7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2afb588386a2d478ff966f13ce0299227d3fda071e49a511015a3deb20f12132"
    sha256 cellar: :any_skip_relocation, ventura:        "4b38ab947bb826e883857d2a34e279c0698a2d1e101f7b4241abcdfdf748c37f"
    sha256 cellar: :any_skip_relocation, monterey:       "e71c5451b0476bb5127890cbca874940af49132676095a36b9429ca2ee1305be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944427377be6c2a0ead2f53438157210c3afd48ac2656e4199ee8af28c38793c"
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
    url "https://files.pythonhosted.org/packages/24/bb/d2e0948bae0cb688c6cfcc976d582dfd2ad7a7987b9220570adbdc317bfb/boto3-stubs-1.34.32.tar.gz"
    sha256 "077f13b0856862bedafb92b8499b960624d06f684595be701fade51a8e9615ed"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/00/4e/5fae13aae6d33ea94d7d8451f15ab2b38788458eb01804c69f0b5d923a1b/botocore_stubs-1.34.35.tar.gz"
    sha256 "df5d8f369820a64cb84f124a2841b62030f3e86b6bd07949376efab31c3845c5"
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
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/3f/e0/a89e8120faea1edbfca1a9b171cff7f2bf62ec860bbafcb2c2387c0317be/flask-3.0.2.tar.gz"
    sha256 "822c03f4b799204250a7ee84b1eddc40665395333973dfb9deebfe425fefcb7d"
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
    url "https://files.pythonhosted.org/packages/d4/33/535ec20237e9f1cc22bcd2adcf296c1b4d63ea92801d3706d1bc0f6120af/mypy-boto3-cloudformation-1.34.32.tar.gz"
    sha256 "49d04c090dae3fd8289738ae592cac9d6faa5169684de40c2730b425bba2a32d"
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
    url "https://files.pythonhosted.org/packages/16/f8/a420878066d6bc684a6360c47117b1a068be29fd5a89a644b04eee1b7a0c/mypy-boto3-s3-1.34.14.tar.gz"
    sha256 "71c39ab0623cdb442d225b71c1783f6a513cff4c4a13505a2efbb2e3aff2e965"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/0b/7e/1850db88a985b7b044ab3c49e2cb5f2cebd531f01f228b86504cdffedef7/mypy-boto3-schemas-1.34.0.tar.gz"
    sha256 "3b25a71944192b0980c3bb5132deb7c06ee9b88580ed63f257fad97cf3bf2927"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/c0/89/727c36fc91d78e9fb3708c98a9809ef4f8f5b07d793e05b69f4a61290d24/mypy-boto3-secretsmanager-1.34.17.tar.gz"
    sha256 "a547932d99c3f711b27b9ea1c38fc063050910c0bf6c8eb346abd96ace61668e"
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
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/54/1f/a435977c79c316224010d0fa0bd85ae48440e11fd0f530df8be964bef791/types_awscrt-0.20.3.tar.gz"
    sha256 "06a859189a329ca8e66d56ceeef2391488e39b878fbd2141f115eab4d416fe22"
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