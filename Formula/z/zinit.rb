class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https:zdharma-continuum.github.iozinitwiki"
  url "https:github.comzdharma-continuumzinitarchiverefstagsv3.12.1.tar.gz"
  sha256 "984a437aa8840158293bced470823855219e56620e05ffcfbc4831bba68e252e"
  license "MIT"
  head "https:github.comzdharma-continuumzinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3555b20575dea025af44e4d0f0b528e65d1d0d7a70fe864c8c14ade6c413446d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3555b20575dea025af44e4d0f0b528e65d1d0d7a70fe864c8c14ade6c413446d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3555b20575dea025af44e4d0f0b528e65d1d0d7a70fe864c8c14ade6c413446d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eabf2f9418ae0b0ed6764d4abb6a0ee7d98e8329fd2b9726ee99562e75216f2"
    sha256 cellar: :any_skip_relocation, ventura:        "3eabf2f9418ae0b0ed6764d4abb6a0ee7d98e8329fd2b9726ee99562e75216f2"
    sha256 cellar: :any_skip_relocation, monterey:       "3eabf2f9418ae0b0ed6764d4abb6a0ee7d98e8329fd2b9726ee99562e75216f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3555b20575dea025af44e4d0f0b528e65d1d0d7a70fe864c8c14ade6c413446d"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix"doczinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~.zshrc:
        source #{opt_prefix}zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}zinit.zsh && zinit load zsh-userszsh-autosuggestions"
  end
end