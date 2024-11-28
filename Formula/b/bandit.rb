class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackages57c3bea54f22cdc8224f0ace18b2cf86c6adf7010285d0ed51b703af9910c5b2bandit-1.8.0.tar.gz"
  sha256 "b5bfe55a095abd9fe20099178a7c6c060f844bfd4fe4c76d28e35e4c52b9d31e"
  license "Apache-2.0"
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2861a95b6146e7c2036a7739ac5d959f9420344823ceb0051070230331a3dc14"
    sha256 cellar: :any,                 arm64_sonoma:  "afb67b338fba2d20b90eaa3e572061c23c8cacca15742d5a97b1a8206d31faca"
    sha256 cellar: :any,                 arm64_ventura: "da978f631964da2592f1672047ad696d881f828e9f6f482ca55639d9997b3971"
    sha256 cellar: :any,                 sonoma:        "10807ed7a5734bb96e90c571458d8c98dfd5eef7fffffc38b34cf56a985827ea"
    sha256 cellar: :any,                 ventura:       "07b23cd656973d2894a7d0b8ab0b2be4c8b1e6a1debf90f550e149c6feb17a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b653512b053c974c56d2e03f21ffa1f183bbbce386792b43dd4220cf91eca44b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackagesb23580cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackages4ae94eedccff8332cc40cc60ddd3b28d4c3e255ee7e9c65679fa4533ab98f598stevedore-5.4.0.tar.gz"
    sha256 "79e92235ecb828fe952b6b8b0c6c87863248631922c8e8e0fa5b17b232c4514d"
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