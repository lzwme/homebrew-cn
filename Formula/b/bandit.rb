class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/fb/b5/7eb834e213d6f73aace21938e5e90425c92e5f42abafaf8a6d5d21beed51/bandit-1.8.6.tar.gz"
  sha256 "dbfe9c25fc6961c2078593de55fd19f2559f9e45b99f1272341f5b95dea4e56b"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ef5c4732e7adcac576f695ebeec098d8868cd5d948b79090d0a1ba481b0b9b74"
    sha256 cellar: :any,                 arm64_sequoia: "24af38a92df7381746b2621706fc28181c505cb50305c82a1bb28e5a643fa279"
    sha256 cellar: :any,                 arm64_sonoma:  "ef0d63ce2a5a05d7ea9c675eff0ad7fbc0547f21ff5e2cafb52cc75bd2a570f4"
    sha256 cellar: :any,                 sonoma:        "c3f8a60a0aee4d8c6da4e4f7e0a62b48d9acb8a8851a51c3da769a8a2be33d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167da002a52b508e69a7516adffb1600504961adee462771322fac8d844df95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8f41c6895a95989db6e060a25c3340eea577b5224c004e099fe5cb37576b9b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end