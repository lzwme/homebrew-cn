class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackagesdde27a61b7c1a6d25e97e3512474332d26782601c06071d0259ea92061125620dolphie-3.3.1.tar.gz"
  sha256 "0ba7b50764a751f501095a3b87e33ed4271ef24e1255f786ee91bc13c908a02a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "029c68586ee231cdd5af4998840ed012de214e914c30695a557d91573c4fc35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81cba858788aa4406cf966ccfe2b9e7328cc5c6654816b3f60b1c5593070c23d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d62bb5902822f7a170749b2fbd45f4af14d5d774c8c132f017f39fcca0e66c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e6489ebb443cd9f5d296e6fc5b687c5937ac9cb16060e44eb2b539fdb51fb9d"
    sha256 cellar: :any_skip_relocation, ventura:        "389206dc118305aba39ae10854e4b54c6b649bc77713659b6086aa7aa4895d78"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0f2628873c96bec287dd00030abda4d19c6969e7d30310e227cddbca2039c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ee09f7099f7d257a27409e9840f53e2dccce98d1e8250b7a98ee0b3127a0d9"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-requests"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "sqlparse"

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages8dfd73bb30ec2b3cd952fe139a79a40ce5f5fd0280dd2cc1de94c93ea6a714d2linkify-it-py-2.0.2.tar.gz"
    sha256 "19f3060727842c254c808e99d465c80c49d2c7306788140987a1a7a29b0d6ad2"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackagesb4db61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0cmdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "myloginpath" do
    url "https:files.pythonhosted.orgpackages21309acf030d204770c1134e130e8eb1293ce5ecd6a72046aaca68fbd76ead00myloginpath-0.0.4.tar.gz"
    sha256 "c44b8d11e8f35a02eeac4b88bf244203c09cc496bfa19ce99a79561c038f9d09"
  end

  resource "plotext" do
    url "https:files.pythonhosted.orgpackages27d758f5ec766e41f8338f04ec47dbd3465db04fbe2a6107bca5f0670ced253aplotext-5.2.8.tar.gz"
    sha256 "319a287baabeb8576a711995f973a2eba631c887aa6b0f33ab016f12c50ffebe"
  end

  resource "pymysql" do
    url "https:files.pythonhosted.orgpackages419dee68dee1c8821c839bb31e6e5f40e61035a5278f7c1307dde758f0c90452PyMySQL-1.1.0.tar.gz"
    sha256 "4f13a7df8bf36a51e81dd9f3605fede45a4878fe02f9236349fd82a3f0612f96"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages245157eb835afc9569d32b5979ecbf3bf73f8ece8700ebffab3bac7ff29f92e4textual-0.47.1.tar.gz"
    sha256 "4b82e317884bb1092f693f474c319ceb068b5a0b128b121f1aa53a2d48b4b80c"
  end

  resource "textual-autocomplete" do
    url "https:files.pythonhosted.orgpackagesc34f6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages75db241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017fuc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https:github.comHomebrewhomebrew-corepull152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}dolphie mysql:user:password@host:port 2>&1")
    assert_match "Invalid URI: Port could not be cast to integer value as 'port'", output

    assert_match version.to_s, shell_output("#{bin}dolphie --version")
  end
end