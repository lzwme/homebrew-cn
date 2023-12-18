class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackages0ac12a5e77affec2692b159274ff836f1f385beb6f9d00c961536599f6ae4bffdolphie-3.2.0.tar.gz"
  sha256 "d9b6c309183c69a67a5526207002492644d3e01bc282a1a3ecda6cb5c5b875dc"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42a9ee149e564fbf6fe2c3060153826d18793e549d62dcbef46bc849964d1ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdc0a9bc8e7dfd2b7b17cd3f451b2a8d2181bc03edd0c3d9261b36aa3b826f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e386634507ba08666a98c6f9a98f7c755b68d1cad5ed308f4a84d630b7a1c12a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fad846b21c544865608372b9603fe0fb447486ed287232e81ab180d2ca648856"
    sha256 cellar: :any_skip_relocation, ventura:        "78b040e0ec288c42df8a2e2efbae0c420ed256232d7c69eccb274aeefecc0ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "836545725bae7b3f8c30f02205153f8c26849f329deae905a48fb9ed6ae4d908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2464c7e734b90d97acfa3420c7f2e31ebf95445ab25bc847d12685c919098fc7"
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

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages3344ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

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
    url "https:files.pythonhosted.orgpackages04db47913d93759a5e64802ecc7c61e1dddca1496a2c7edbf6c7b73f2f253f52textual-0.41.0.tar.gz"
    sha256 "73fb675a90ddded17d59ebd864dedaf82a3e7377e68ba1601581281dfd47ea86"
  end

  resource "textual-autocomplete" do
    url "https:files.pythonhosted.orgpackagesc34f6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages75db241444fe6df6970a4c18d227193cad77fab7cec55d98e296099147de017fuc-micro-py-1.0.2.tar.gz"
    sha256 "30ae2ac9c49f39ac6dce743bd187fcd2b574b16ca095fa74cd9396795c954c54"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https:github.comHomebrewhomebrew-corepull152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}dolphie mysql:dolphie:test@localhost:3306 2>&1")
    assert_match "Failed to connect to database host", output

    assert_match version.to_s, shell_output("#{bin}dolphie --version")
  end
end