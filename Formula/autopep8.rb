class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/b5/13/d3b4adad46dd3ce96e293345e1efe660d405f3ee3f4289304dca8a4e5544/autopep8-2.0.1.tar.gz"
  sha256 "d27a8929d8dcd21c0f4b3859d2d07c6c25273727b98afc984c039df0f0d86566"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e719ab68f67bf68be74c7c8ff38bfa56af73031353783515410aaf10b87748a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e719ab68f67bf68be74c7c8ff38bfa56af73031353783515410aaf10b87748a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e719ab68f67bf68be74c7c8ff38bfa56af73031353783515410aaf10b87748a"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7a1d6da1b755fbeffb6dd43494e0d6214f06db8c4d9a7410ffadedde78dd06"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7a1d6da1b755fbeffb6dd43494e0d6214f06db8c4d9a7410ffadedde78dd06"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7a1d6da1b755fbeffb6dd43494e0d6214f06db8c4d9a7410ffadedde78dd06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04aff7800704642d14e79cb0fbe23e8223524d569feeaca61e34e68ddbb82e43"
  end

  depends_on "python@3.11"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/06/6b/5ca0d12ef7dcf7d20dfa35287d02297f3e0f9e515da5183654c03a9636ce/pycodestyle-2.10.0.tar.gz"
    sha256 "347187bdb476329d98f695c213d7295a846d1152ff4fe9bacb8a9590b8ee7053"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end