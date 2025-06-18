class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https:github.comPyCQAbandit"
  url "https:files.pythonhosted.orgpackages4e01b2ce2f54db060ed7b25960892b275ad8238ca15f5a8821b09f8e7f75870dbandit-1.8.5.tar.gz"
  sha256 "db812e9c39b8868c0fed5278b77fffbbaba828b4891bc80e34b9c50373201cfd"
  license "Apache-2.0"
  head "https:github.comPyCQAbandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "433446f0a00382f4d134e458bfae5482dbb0a139fcc144ae65578656ebdf8cd6"
    sha256 cellar: :any,                 arm64_sonoma:  "95148b9d41699d7f135b86d18e0fc4a0c717e7b6f1579f858cde9a5f6141d21e"
    sha256 cellar: :any,                 arm64_ventura: "c0500467fe18f4e97a1935cb60fb92c3c7b8c1b588806cc5d841efddb62e99b5"
    sha256 cellar: :any,                 sonoma:        "092ba89ceb814c02a2c5b5c91a0377c4503b4c7ddd426ed15e580ee03adbbaab"
    sha256 cellar: :any,                 ventura:       "4f0ed8c5331aff4b98bcf686c2da3208cf2f750dc86bde1b7f89c234dc703c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f6117e4e209b5711d64ba19c31e8a837bfdfc70fc0d80e52d40d0aa8868f7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a112b745e37ab7aca2000f18dd0f5b2166cac53c2ef810af9617493423b91317"
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
    url "https:files.pythonhosted.orgpackages01d2510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
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
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackages283f13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
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