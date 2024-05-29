class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https:github.comhhattoautopep8"
  url "https:files.pythonhosted.orgpackagesd7881a1460a39c5ed907115f96a396e720ad6c9bc75b9b8b3502ddef39863e30autopep8-2.1.2.tar.gz"
  sha256 "77b07146bf127aa88de78efc270d395a54ebb8284fdbe6542c4aeb8d969f4d9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, ventura:        "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fac1e4d58a523a44632691424baf45914ca71fb4837dd1c6e32a3f6810e649e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6072db59d6c2ebcc7379e6c4724121ccd5e1e3ba5195ac42b465a0811ba0f3"
  end

  depends_on "python@3.12"

  resource "pycodestyle" do
    url "https:files.pythonhosted.orgpackages348ffa09ae2acc737b9507b5734a9aec9a2b35fa73409982f57db1b42f8c3c65pycodestyle-2.11.1.tar.gz"
    sha256 "41ba0e7afc9752dfb53ced5489e89f8186be00e599e712660695b7a75ff2663f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end