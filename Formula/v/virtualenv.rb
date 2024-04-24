class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackagesd8020737e7aca2f7df4a7e4bfcd4de73aaad3ae6465da0940b77d222b753b474virtualenv-20.26.0.tar.gz"
  sha256 "ec25a9671a5102c8d2657f62792a27b48f016664c6873f6beed3800008577210"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe01d126afa05023ab76ca58698f174a8499fc3e07b38796b3ddcc71fabcb2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, ventura:        "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, monterey:       "89344d38f45eb8e75a560f0810a34616c4e3dcfa04c12ee64ec11933f85be21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5463b74953eb67be500e6d08fe9a43a79a1413fe670ac57208c055d51d820576"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages38ff877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesb2e42856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dirbinpython -c 'import sys; print(sys.prefix)'")
  end
end