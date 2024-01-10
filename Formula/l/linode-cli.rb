class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https:www.linode.comproductscli"
  url "https:files.pythonhosted.orgpackages1712f8f12c2b9d67a3cc9fc11a87a1f6d580a4354a09591a3a7c6a56f17accd0linode-cli-5.48.0.tar.gz"
  sha256 "6fff9321b948fefacfca1bceed80575b10e189482d05ef9da49cc5708ad02de5"
  license "BSD-3-Clause"
  head "https:github.comlinodelinode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa8febdf2dd11e9695a3e16204bae0f879f2284166ca5467611459e56ab0d882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16db0cc8f0c07ba39ee356e0c8cadf1b1b4b733e115c29f153bf7415ce1077a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83bc97ea5540afac724bfa03b4cffbc49d086cb3cc120c8e9de996c2149a5d71"
    sha256 cellar: :any_skip_relocation, sonoma:         "f69b10aa668e4e9bd5e730968e88f7a7939ba58202673c6c64f2a6f2de7f52fd"
    sha256 cellar: :any_skip_relocation, ventura:        "32511775dfe511e8ac9f0ce7fcff4c035ba762a4c997e455276086b9d3a68f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c40e260e8f2b44325c95c89f98ac5166167309da9b679e2a423f471e4c4ead7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6b933e8fc4696d5d13e6e54568287528a47d890acbaaf28b5e6020159ddd97"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https:raw.githubusercontent.comlinodelinode-api-docsrefstagsv4.170.0openapi.yaml"
    sha256 "6ded7499c9ef0390326ee36ea62cec5741d720271272f1af91293081fd3c0189"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "linode-metadata" do
    url "https:files.pythonhosted.orgpackages907d8cfe943f15fb47643998c1ae3f331e10df66e88d9a67ccfbb295b00aad58linode_metadata-0.1.0.tar.gz"
    sha256 "33743f83aa9fec743556c0f101e6e8bcf15e6aa7cd9994d971e0ec22419ae11d"
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
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name == "linode-api-spec" }
    buildpath.install resource("linode-api-spec")

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system libexec"binpython3", "-m", "linodecli", "bake", ".openapi.yaml", "--skip-config"
    # Distribute the pickled spec object with the module
    cp "data-3", "linodecli"

    inreplace "setup.py" do |s|
      s.gsub! "version=version,", "version='#{version}',"
      # Prevent setup.py from installing the bash_completion script
      s.gsub! "data_files=get_baked_files(),", ""
    end

    bash_completion.install "linode-cli.sh" => "linode-cli"

    venv.pip_install_and_link buildpath
  end

  test do
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