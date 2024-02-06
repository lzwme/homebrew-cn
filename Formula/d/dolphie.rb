class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https:github.comcharles-001dolphie"
  url "https:files.pythonhosted.orgpackagese831b2dbd18f79f9cf3f2defa2aa80b1d6cca85342ffa04f9de1cdb8c6685af6dolphie-4.0.0.tar.gz"
  sha256 "e472da921d35ef13a52eda103fcf4c06d091090f3f25287146526277076676fd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5148ea236eefdc37b489213e9dfbc4aed08f1f464376478aa3f59ba5a4558bc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "070a2a4d124f644bb143422d82bd7ca92b5c6047f6ca65ba8271d517fa9b934f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90932e19b4f069ed132cd5d17621b1ab3be85b90d5fe5db337335a7373893f33"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e3a1471375104d448c8bcf6b5e7ea630632e84e268fbf89fbdec53325899348"
    sha256 cellar: :any_skip_relocation, ventura:        "95f4c55eda529ef99210cd05b9c5a652dfe1ded217004ee8a71519aa55282d55"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8fd8bb15bc3f24817abdcdd91eebdd2ef0ef9b873d8f20b1e14c3c18236804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c4d289f86347de4a374b47ae4800dbf0ccca57f31b7139731c49a798dfa844"
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
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
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
    url "https:files.pythonhosted.orgpackagesa8c4b19c89d2ad42c0be92aa773bb86bc4e028f30166edd032c49f148c0bc652textual-0.48.2.tar.gz"
    sha256 "e092dffa5311f3381cb5f51d56c506143f5c1ee3b1c67f57bb1929cfa73fee07"
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