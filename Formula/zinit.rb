class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://ghproxy.com/https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "f8c01adabd02dd8d67300b7156f39ed3ad56e051bdd9e76fff74eb0e74983862"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a719197b0d944091ea093b9ee3f9930d82fbb09e4b486d8ae7dce735b45e98d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a719197b0d944091ea093b9ee3f9930d82fbb09e4b486d8ae7dce735b45e98d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a719197b0d944091ea093b9ee3f9930d82fbb09e4b486d8ae7dce735b45e98d0"
    sha256 cellar: :any_skip_relocation, ventura:        "ac87654064b80b0e36d004ff2ebccc72e9078509273ebe14bb81bf6061696092"
    sha256 cellar: :any_skip_relocation, monterey:       "ac87654064b80b0e36d004ff2ebccc72e9078509273ebe14bb81bf6061696092"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac87654064b80b0e36d004ff2ebccc72e9078509273ebe14bb81bf6061696092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a719197b0d944091ea093b9ee3f9930d82fbb09e4b486d8ae7dce735b45e98d0"
  end

  uses_from_macos "zsh"

  def install
    man1.install "doc/zinit.1"
    prefix.install Dir["*"]
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