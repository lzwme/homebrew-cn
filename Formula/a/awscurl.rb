class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/c8/77/7da6af880d56aed4a4023bb7c725e15c72a3088afd729ffd373eed0f5a18/awscurl-0.44.tar.gz"
  sha256 "13056e867ac33f556f29d3662102bfc3c40259ea037c6d817c5914dbb2bbd948"
  license "MIT"
  revision 5
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6aad3862663e7f6024ba443c43412e5a5b44c4373791e6a99be1a0e828de2c70"
    sha256 cellar: :any, arm64_tahoe:       "8b4cd073823284cae9e16f2141f26f320ac9fb2dc5756bf93c52e9f1f430d7d1"
    sha256 cellar: :any, arm64_sequoia:     "3ce8f85417f3304d6dd61a6bc89fe5739519a27e011556bbec2e943e0de46bc7"
    sha256 cellar: :any, arm64_linux:       "9277a32310b9615385fa19d0be8a32ea87b38c11397966c264f20ce8c8fd1c86"
    sha256 cellar: :any, x86_64_linux:      "5ab357402d57f19715ec1ee6201c87e6bc734b1be6ee07841bc49928bf6d4334"
  end

  depends_on "cmake" => :build # for `awscrt`
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@3" # for `awscrt`
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "s2n"
  end

  pypi_packages exclude_packages: ["certifi", "cryptography"]

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/93/bc/9a88ccd0f764a61fbc0f40b600d099110e3b16cf68fc92a401c3c953cfb3/awscrt-0.37.0.tar.gz"
    sha256 "9e2ddadc609084b5f60affb8b87e77304fed64e271e2b2b7558186cf65d81e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/75/46/d8c87ada70a7647fb3d206c7f19eafca3580a0ae4c06d62da539a1ee1207/boto3-1.43.105.tar.gz"
    sha256 "e51260aed9cc1474778b5488bc6f97ad28f27a0a7002f4bbaaf8191aff1422ea"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/30/668f3c0533a440787e212cf56404cb6ec234ae8e6baf97fe17329d512d88/botocore-1.43.105.tar.gz"
    sha256 "afb3e7706b123ab069d1c34571ca1fdf82528a48425574fe4693df3d039d503f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/5d/ed/33c0ba7f0b5be384ff8a2101ce77728f219e816b2104819f1651477e1ad5/configargparse-1.8.0.tar.gz"
    sha256 "22a417f4d7b00149f0af82ef7c491f8ecc4b1d5454633fd319b386f5eb806f92"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/8b/ac/ea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7/configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "The AWS Access Key Id you provided does not exist in our records.",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com")
  end
end