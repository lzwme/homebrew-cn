class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/bc/9b/f425ff02c84a16e434526d3ffe7abfc50589f46a5efe9b02cfd09bec698e/trailscraper-0.8.1.tar.gz"
  sha256 "fe0f7970554a7100be6a4dc6ecce0ce0f4a5a3337a689e7035df7ac3c37ec21a"
  license "Apache-2.0"
  revision 2
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bad4033138571ec995b7a9fc4e53d35a45d06b0456a30c6c9f07c5bb8c5e92c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c37483d9c3c3a5dc39c20dd7c1b8575817cfc48da8f2b370554b7cbdf354b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "146d4631fdbacbab842cff1d0aaad787ba2cb7ba06b74f0bb97a02d3a5079e92"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e8a3d69c99cc169b399614508ea11ee8012badc38151997d15e0235915f81c3"
    sha256 cellar: :any_skip_relocation, ventura:        "6ed20d00a4f943f3048a1394e59bc41dac3daff9cfe199865e378f5c252d46e4"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa7270582adcb00f810f0a9dc4f084c72d4905e4e984fc54119029d23a7242c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c609494a3611d6323d43fa4830d9ea745fe65aa1ab4625174b32985f5e604779"
  end

  depends_on "python-pytz"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/95/60/88c7932476b438fc4702daa0dc6f5663c8c1451898d3d7daa0f934468086/boto3-1.26.54.tar.gz"
    sha256 "4e876ba5d64928cde0c416dd844f04f22d6b73d14002bbc3ca55591f80f49927"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3d/f6/d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3/botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/bb/2d/2f5dc79f80623f0f7ec4ee5291512caffda18f3ea070cb2775cc7839733f/dateparser-1.1.6.tar.gz"
    sha256 "e703db1815270c020552f4b3e3a981937b48b2cbcfcef5347071b74788dd9214"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end