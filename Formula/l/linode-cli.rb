class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https:www.linode.comproductscli"
  url "https:files.pythonhosted.orgpackagesadee68349e5154176129b98a018b90a774d00c86d598b301a259305c21a43726linode-cli-5.47.0.tar.gz"
  sha256 "ece7206985dafbff1aca8e03aa50b36169c7601a10fc52760673e28e82e69556"
  license "BSD-3-Clause"
  head "https:github.comlinodelinode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e6560f9dd8db968ff32239512516dfab60c3bb4dbed30d02504bbe9b1ee1b3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59c1e8700d29c51bec1e12b28cd025c39ab1790502ddc0bf492aeec904a82f6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "892c4ef0fe7cc8c7b2f331dd8f8fc0ee95d8062973a5592d8c20b78534b94343"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e28c120875bb4e33f8127cd5946b8b80c68b45b4cf7862e37b5d2114a2c1978"
    sha256 cellar: :any_skip_relocation, ventura:        "278e55ab1e8a7dcea1d1da9045bf4b4d2a5542b628eda3b7bc0644dbfec8f24d"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf80d210f5541a1425e079d86fc636bad330f581a538999edcfd6a9d264fd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c94adff328922b2043e75910dd68a194d052d6bc24979a08ef517ca6ba7d3e"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https:raw.githubusercontent.comlinodelinode-api-docsrefstagsv4.167.3openapi.yaml"
    sha256 "43ddaeb31a6ba3cc069555f07188b87f7867be9a386a374ddf0020bf769877d5"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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