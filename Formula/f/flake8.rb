class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https:flake8.pycqa.org"
  url "https:files.pythonhosted.orgpackages58163f2a0bb700ad65ac9663262905a025917c020a3f92f014d2ba8964b4602cflake8-7.1.2.tar.gz"
  sha256 "c586ffd0b41540951ae41af572e6790dbd49fc12b3aa2541685d253d9bd504bd"
  license "MIT"
  head "https:github.comPyCQAflake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8292895a9196bed1a95f2e23df67d054d91ab214a0ab28fc7f7ba10493e6082b"
    sha256 cellar: :any_skip_relocation, ventura:       "8292895a9196bed1a95f2e23df67d054d91ab214a0ab28fc7f7ba10493e6082b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e53312ee99ba86180c06a373785e256fd8145bbb304cf0a76d113fb5fcd3c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6472bbbe85644ceb3ca79ebdad429eba7aad1f29da85c5a5a7324fe952b8c9"
  end

  depends_on "python@3.13"

  resource "mccabe" do
    url "https:files.pythonhosted.orgpackagese7ff0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https:files.pythonhosted.orgpackages43aa210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  resource "pyflakes" do
    url "https:files.pythonhosted.orgpackages57f9669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test-bad.py").write <<~PYTHON
      print ("Hello World!")
    PYTHON

    (testpath"test-good.py").write <<~PYTHON
      print("Hello World!")
    PYTHON

    assert_match "E211", shell_output("#{bin}flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}flake8 test-good.py")
  end
end