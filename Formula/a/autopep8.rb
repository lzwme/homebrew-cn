class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https:github.comhhattoautopep8"
  url "https:files.pythonhosted.orgpackagesa366d3f145d4cb4d240847207a409def85bbb2e11ef43fcfc3ddfcb75110910cautopep8-2.1.1.tar.gz"
  sha256 "bc9b267f14d358a9af574b95e95a661681c60a275ffce419ba5fb4eae9920bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "221d06470dde7031f83ea1770521f0b0c6736539dbb438c6f3d3e6de90702b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b62d7d4a99b876276efcb110a28228717b9fe02fe4f215906607abe28350e135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ab9266be16e905428377c5bd053087278b6249922bdc7e2d09ec9a65b0f214"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d056c9d590c3831d0e992e20c7f1daf2328783a4221c01485f4bb7c361498b1"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc9ffc07a604842734af0a2fbfa2cd8e0d7b7b0c3b87449526c2cd626483799"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8dbd435d8153b37bf5276456e1bb6b618f2142bbd51c52cef0215cc415f1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2b7bed34e7255105e4ba121a041aa419c973aab579b1ad6bf7b09980158222"
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