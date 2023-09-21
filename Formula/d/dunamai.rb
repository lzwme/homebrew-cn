class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/77/c8/845bdb9167570937cada51b586393dded1e77c56db458f350a671c4f1ab9/dunamai-1.18.0.tar.gz"
  sha256 "5200598561ea5ba956a6174c36e402e92206c6a6aa4a93a6c5cb8003ee1e0997"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecb0f63fa62c43e87d625e058a727773adb88d966bb1fa73c0f925cc541d5c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a6c139106ef9979e2d052b9ef7f9adf41a25936b3ed9d197e70bbebefb285c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f613b8e47081d6b5c79302719c9761dcfb1a670a9db650a99d62e6d4e47252"
    sha256 cellar: :any_skip_relocation, ventura:        "fd9cc9d120a0648ec86c98b3e3593c047e51f8363b2b809face37c6522023cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "1f6c6d848c3aacce1c3e55331d768d7d0d2d0f70cbcbb8041f19934d8a8d5a67"
    sha256 cellar: :any_skip_relocation, big_sur:        "1985cf0e853bcdd2a28a5464640b4f50cfd10e85888b4da8f3279374d9c6378c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c403a7a27376bea29bb5bf6d126d735c5a568f01e6ba5190dc2f59df680df9a"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end