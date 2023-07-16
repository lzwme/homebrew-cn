class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/26/c6/169a384bfe44de610f5bbc03b3d4cc23a5a64a75be11864a033f2fe195db/virtualenv-20.24.0.tar.gz"
  sha256 "e2a7cef9da880d693b933db7654367754f14e20650dc60e8ee7385571f8593a3"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f8da79182342a7ff6457ad6b1ec153b2703a98de6bef85dba95e80a32f8d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6c7e42c4ce9c7eef1f81eb49ae9e14dba1a14cc2ed11361cf9e00eb25b19be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82c3a00575a114c89b8c4d7ed2e46f16bcf9ef39ed735db30f315c82786f87e4"
    sha256 cellar: :any_skip_relocation, ventura:        "21141ecb7d282dc172b82f09df992f3a853bb32cac96c31627fac327b800e40c"
    sha256 cellar: :any_skip_relocation, monterey:       "ce7c8ee77336f266ab2076186f2b88c11bc6eaa71b334f306e54b9ccd8893ae6"
    sha256 cellar: :any_skip_relocation, big_sur:        "af716ccf53d80659069dcc3ad5f0bbfd8ec48635e3e9bcaf64334a2a36229916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71f7a4f21e0a2a2f049725aadfabcfdae408ba908e07e69ce4ad73136873c9c"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/92/38/3dd18a282991c004851ea1f0953105a186cfc691eee2792778ac2ca060f8/platformdirs-3.8.1.tar.gz"
    sha256 "f87ca4fcff7d2b0f81c6a748a77973d7af0f4d526f98f308477c3c436c74d528"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end