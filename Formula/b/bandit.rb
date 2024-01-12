class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackagesfa09049dff8b2fa7fc7cf82bd28999a3c97d55727d8235d0d8b3c95ff78b16fdbandit-1.7.6.tar.gz"
  sha256 "72ce7bc9741374d96fb2f1c9a8960829885f1243ffde743de70a19cee353e8f3"
  license "Apache-2.0"
  revision 1
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b5e1ace8a7e5f06cd6078bfd704bc8b1a8031ea31bd351d651c711da42f1909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc9541c49f443e42c7f3e9874e93a704946277eb83f5ed7dfcf58b47aebe2e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18107e95264e506a656b2e4f434dae841a830679038dbe1425d8a8c0209d88ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c942d002d489f723a0133c05d705e59c92da26cf2deca8e5f35bc2d283c41a3"
    sha256 cellar: :any_skip_relocation, ventura:        "cefffe21ae6f279f32c5702820815c51d9c96520d84fe8674da9a8e9c8022b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "36b24a229c9bda8e6cdb066b3957c6f5f00707bd28d430b506309badd6c7fbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d648e797c8d8370e7d5fa5ac8f427a83df3fc4cbc1a532256e2efd61217a504"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagese5c26e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3fGitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

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

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
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