class Kerl < Formula
  desc "Easy building and installing of ErlangOTP instances"
  homepage "https:github.comkerlkerl"
  url "https:github.comkerlkerlarchiverefstags4.4.0.tar.gz"
  sha256 "0f32eb08172baffdca9264c5626f6d7fd650369365079fe21f8b8ab997885d8c"
  license "MIT"
  head "https:github.comkerlkerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e44f6243554ba4b4ff9c6e84a77328a7fd893d842786f402d1a03dde413b3e9"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completionkerl"
    zsh_completion.install "zsh_completion_kerl"
    fish_completion.install "fish_completionkerl.fish"
  end

  test do
    system bin"kerl", "list", "releases"
  end
end