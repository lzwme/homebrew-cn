class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://ghfast.top/https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "e80126c2fcd4a1e8a4ce42d30826fd2fcf4710d6a87addeb1225276128019c8e"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba738027bda34f46cef338325a0a6b2d21301d1d24963a0fbd382a4d1538ae4e"
  end

  uses_from_macos "zsh"

  allow_network_access! :test

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end