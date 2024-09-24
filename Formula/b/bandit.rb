class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackages3826bdd962d6ee781f6229c3fb83483cf9e09d87959150a9000789806d750f3cbandit-1.7.10.tar.gz"
  sha256 "59ed5caf5d92b6ada4bf65bc6437feea4a9da1093384445fed4d472acc6cff7b"
  license "Apache-2.0"
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "085559f0c6f440c80613c31e69d969f8171076c31f48f961cc148dbea4b88303"
    sha256 cellar: :any,                 arm64_sonoma:  "20862faae6e82c9a957a4ef215adae2e43d9a412775f1e32e339e2d1de29c082"
    sha256 cellar: :any,                 arm64_ventura: "5f18e56f67e487f3ef1cc54b945d1d1b778387d39a9e7a7b659bc8585a50fc58"
    sha256 cellar: :any,                 sonoma:        "0a235c60db092203094021e1d422bea7be65263ac236469f5497df8167585afc"
    sha256 cellar: :any,                 ventura:       "25fe608aa208bb9ec711bca636037b62498c7acd4125dbb6d653e62236188f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7481c96d9953dffd2b1217d236aaeb777ede096762246efbdf8d23a761ae478"
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
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesc459f8aefa21020054f553bf7e3b405caec7f8d1f432d9cb47e34aaa244d8d03stevedore-5.3.0.tar.gz"
    sha256 "9a64265f4060312828151c204efbe9b7a9852a0d9228756344dbc7e4023e375a"
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