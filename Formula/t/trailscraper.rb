class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https:github.comfloselltrailscraper"
  url "https:files.pythonhosted.orgpackagesbc9bf425ff02c84a16e434526d3ffe7abfc50589f46a5efe9b02cfd09bec698etrailscraper-0.8.1.tar.gz"
  sha256 "fe0f7970554a7100be6a4dc6ecce0ce0f4a5a3337a689e7035df7ac3c37ec21a"
  license "Apache-2.0"
  revision 2
  head "https:github.comfloselltrailscraper.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "058062c73bda5546dfa1b4041a9c36d914935989e2c8efc1caa3b4c46d875d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3e6a790e68aa6a52f86a246957295b8e7030486360ef2fa32f44dfcfba3849f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d76e5e9699584d67254b86f144d32c7800a908595b68b3fc2c20265c8a5e07e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "447a2384b43f7672a54a515a368fa9dee918f809cec4b77e702f093b011b169f"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4849e3e049ff4f634f253396f3d52f3cfd3ff212b376c348e0aae1349caba9"
    sha256 cellar: :any_skip_relocation, monterey:       "d746bfff2f0f5cc387bda439cf3a3e821adb65d17af72c0b2a4daba279081798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5896b62702afcdcaa61a47fdaa02315e6642376451b5a7c207bebdd7f504fb99"
  end

  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-pytz"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages956088c7932476b438fc4702daa0dc6f5663c8c1451898d3d7daa0f934468086boto3-1.26.54.tar.gz"
    sha256 "4e876ba5d64928cde0c416dd844f04f22d6b73d14002bbc3ca55591f80f49927"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages3df6d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "dateparser" do
    url "https:files.pythonhosted.orgpackagesbb2d2f5dc79f80623f0f7ec4ee5291512caffda18f3ea070cb2775cc7839733fdateparser-1.1.6.tar.gz"
    sha256 "e703db1815270c020552f4b3e3a981937b48b2cbcfcef5347071b74788dd9214"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages6b3849d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0dregex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages46a96ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3cruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages5a47d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecfs3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "toolz" do
    url "https:files.pythonhosted.orgpackagescf052008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackagesb2e2adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0atzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"trailscraper", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}trailscraper generate", test_input)
    assert_match "Statement", output
  end
end