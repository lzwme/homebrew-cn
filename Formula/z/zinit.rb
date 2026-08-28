class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://ghfast.top/https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.15.2.tar.gz"
  sha256 "b1b6a98358c8285df5a1b4ee02b1f96c7356b3f35dce5232f229a30693ebf57b"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "599ce7c1a9d7bd312b7bf0f78d81f038cc38e606c7bd124307c51ee2912c0867"
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