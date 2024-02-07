class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https:www.linode.comproductscli"
  url "https:files.pythonhosted.orgpackagesa8623c2d1a1c63df38533bf4ab5ed2a956168f3eedaca96fdea447bb69fc3b5clinode-cli-5.48.2.tar.gz"
  sha256 "5c591987ecee00aab27591591d0cb2aaf3b33baeb99c9726ed405c6e752d2b76"
  license "BSD-3-Clause"
  head "https:github.comlinodelinode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a1c772355adf364c108cc377843c67f0f4bbc21babe7eedf57dd58e526a2819"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5abe3c19e3c67ba26385b834715753fe7f96a02cb33a999053ad0a62c484c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2915b348835a919399cf605158ba379eb9ba8275de742bfcd2c4548407f5fad1"
    sha256 cellar: :any_skip_relocation, sonoma:         "84291d27f801f650e6bddc4e8742417b8db2632c6d45d13988320134b75c816e"
    sha256 cellar: :any_skip_relocation, ventura:        "b14f8e4116cf836358e031fb9cd630e62f30ba2b2568703fca043dcb43d9f237"
    sha256 cellar: :any_skip_relocation, monterey:       "1485ca85542c92a39779bb051ef1aa878b2ae6fd0ad9a0758be784bcf8f23e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235dbccc3ae885cacfde7e49e1877d0678187cebbda01525636fd8efbbde3b35"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "linode-metadata" do
    url "https:files.pythonhosted.orgpackages90468cecde538b392d96abbb85b72bf3b31479b645d2853d6e64ff8888a3c37alinode_metadata-0.2.0.tar.gz"
    sha256 "6877193ae74f8b798c35021167b969877d8b4b376f8fa0013c04f331d528000c"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi3" do
    url "https:files.pythonhosted.orgpackages940ae7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5bopenapi3-1.8.2.tar.gz"
    sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese2ccabf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    # Prevent setup.py from installing the bash_completion script
    inreplace "setup.py", "data_files=get_baked_files(),", ""
    virtualenv_install_with_resources
    bash_completion.install "linode-cli.sh" => "linode-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}linode-cli --version")

    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end