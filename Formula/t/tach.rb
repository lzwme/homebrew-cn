class Tach < Formula
  include Language::Python::Virtualenv

  desc "Tool to enforce dependencies using modular architecture"
  homepage "https:docs.gauge.shgetting-startedintroduction"
  url "https:files.pythonhosted.orgpackages55e7b088b681f6fe586b6480ffe0a6c03caa1f339b8758ece81b40059a85d68dtach-0.28.4.tar.gz"
  sha256 "ea6a0cc4b620119f169d02a81b63e16a478b8ea19874e12535cce573df516f13"
  license "MIT"
  head "https:github.comgauge-shtach.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bbf38335384981b7a00f489e27152c62ec2b5ab1a9d34703dfa9f2af38e6fb3"
    sha256 cellar: :any,                 arm64_sonoma:  "4aadb6e7db557c5e50c74fe4ee8339d1d8de8415e75d57bd17ec32cefc245a7f"
    sha256 cellar: :any,                 arm64_ventura: "52390d677cb19c6a62424f934a96a14c671536a8a2e3343a9e48040e3a50113e"
    sha256 cellar: :any,                 sonoma:        "ef35282ee28ce502baa2791f7d93dcdae99018bfbdcd81487e9e821bb5ec3789"
    sha256 cellar: :any,                 ventura:       "0795130f609f5e165ff4f2481c0218ebf63dc291707e1321df393370a4dce759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc49a0bfd2dae08f6fb357e7ad01eb0c413c2feb9fa623aba042c45ca1c4c805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa39e3313e447310022df785e8d430cdf59f9558adbca4b64dfe1e1e240f479"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesfd1d06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937fnetworkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackages66dde0e6a4fb84c22050f6a9701ad9fd6a67ef82faa7ba97b97eb6fdc6b49b34pydot-3.0.4.tar.gz"
    sha256 "3ce88b2558f3808b0376f22bfa6c263909e1c3981e2a7b629b65b451eee4a25d"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1887302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4fftomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https:files.pythonhosted.orgpackages1975241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fetomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tach --version")

    assert_match "Configuration file not found.", shell_output("#{bin}tach server 2>&1", 1)
  end
end