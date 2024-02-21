class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackages5004f9efce9197981a6b36e44433c3f7349016f92ab69ddf9f9339d2fce0720dbandit-1.7.7.tar.gz"
  sha256 "527906bec6088cb499aae31bc962864b4e77569e9d529ee51df3a93b4b8ab28a"
  license "Apache-2.0"
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bed4caef90fdd2eee19df3bd93c70ecabea8ac927c29cce458850c5453e1536e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e4ff1807516e86a435fd252ed16bd93c86a9554980b71d7b6403b43c80726b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca5aa10cc3e02a4be271327a49cfd777c5e58888fd7b2a6149925c834ada4bc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e59e0a882806c5bfbb242b75e194f2a650c01ce7ef34b92a38a2a3e5fb5ef310"
    sha256 cellar: :any_skip_relocation, ventura:        "2cade83f48aaf252631be55e06c71506f000d69cba0d8b096c0180833af28d52"
    sha256 cellar: :any_skip_relocation, monterey:       "fb13b18e8ef4d2a95be16755aeeed8421a9cd7b61aebeb94626585bd1289a83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958b3660e1d179341f41aa13417d2d53b05afe8be88c2292a15466ae7857e2d6"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end