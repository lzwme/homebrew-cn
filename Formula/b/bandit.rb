class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackages0aa4030de3683f7abda813cc545b4b198842a5ef4ce9cb51a0bc103e14be1e97bandit-1.8.1.tar.gz"
  sha256 "692553451fb36864c80663cd0d8a0015a2a25359d4c2fdea5255708eb7a82013"
  license "Apache-2.0"
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a15de121cb9ecad8145ae2c8ee54040e5a2a194ea7b6f476e7b555c1ce6198d"
    sha256 cellar: :any,                 arm64_sonoma:  "b59384b517e005b1d196ec9c6ddb99028f060867f8d2c98e101a1a8af4df9b9e"
    sha256 cellar: :any,                 arm64_ventura: "2c30af1ab138975b9b48bde73783d0ec43718f5443785d2d1cb8df4604854c67"
    sha256 cellar: :any,                 sonoma:        "e65fb943305d140ab15d5669b962e31555361242b27b4c615ba09f02017d53ea"
    sha256 cellar: :any,                 ventura:       "7ed1e0f0ea03eaec6cdbf646cb8790538912b9bc3f75af2a4db1f68cc761d51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6fceb58bac873410a4b1cd258e1becb30b85eed3c2dc8ab5cc21782eeb646b"
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
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
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