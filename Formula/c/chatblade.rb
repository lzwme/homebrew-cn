class Chatblade < Formula
  include Language::Python::Virtualenv

  desc "CLI Swiss Army Knife for ChatGPT"
  homepage "https:github.comnpivchatblade"
  url "https:files.pythonhosted.orgpackagesae80a3f146f221fbd529743e1baf871c630948d52cd9acca94027f1c23b62e23chatblade-0.3.4.tar.gz"
  sha256 "3830bc9f8252ec839f009327ec23f325c04d3217c3e40dde12a5542b57b89996"
  license "GPL-3.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "8b784f067c8aa8f0a24ced816f96ab7424152261922c06db1ee56a95cd7c4145"
    sha256 cellar: :any,                 arm64_ventura:  "694109fef38866b62e17177c500c99e663703e6d4ddaec99641d46c220732166"
    sha256 cellar: :any,                 arm64_monterey: "14202b718d312aa6fcdf7f3b0667d948c949cd11cbb41d7a85c3d143736700c9"
    sha256 cellar: :any,                 sonoma:         "51dd86e0def51aac7ddd5f5d29af6b728d97d70047c011078a862a5eafe89f91"
    sha256 cellar: :any,                 ventura:        "8e02ff89bc64c3be421106c561eeff0f4ab88fb835ae7f7e1d107a11872c985a"
    sha256 cellar: :any,                 monterey:       "cab6f0427536d09d9c46afe90c170d9f675c4070a1bf1143262ca458711f3118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7a098bc0b22f563f24d85f3c6d51afc1c09ab673577d9e9bd93ee263906839"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages28992dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfceanyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages185678a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages1cfec0523094193929a68b288e0ae3eb865725f1ee9faca0f21693a86e96c943httpx-0.25.1.tar.gz"
    sha256 "ffd96d5cf901e63863d9f1b4b6807861dbea4d301613415d9e6e57ead15fc5d0"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackages13046757d80c3129fef0ca821e5ccc3764f3db5a0a3de141b7e952ef15133e97openai-1.2.3.tar.gz"
    sha256 "800d206ec02c8310400f07b3bb52e158751f3a419e75d080117d913f358bf0d5"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesd3e3aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesdfe84f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesaf318e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6ecapydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages6b3849d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0dregex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb10ee5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackagesbdef91777d3310589c55da4bf0fafa10fdc8ddefa30aa7dfa67b2fc8825bc1f1tiktoken-0.5.1.tar.gz"
    sha256 "27e773564232004f4f810fd1f85236673ec3a56ed7f1206fc9ed8670ebedb97a"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "gpt-3.5-turbo", shell_output("#{bin}chatblade -t count tokens")
  end
end