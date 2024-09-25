class Kerl < Formula
  desc "Easy building and installing of ErlangOTP instances"
  homepage "https:github.comkerlkerl"
  url "https:github.comkerlkerlarchiverefstags4.3.0.tar.gz"
  sha256 "3270070f4a61a080508810a9fea2a3173439cc5dcaf12ea69ca8baf0d68aadd9"
  license "MIT"
  head "https:github.comkerlkerl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5c6a6d8332eeea9cc03e8bbdf5cb26b8f85a6cb636e1127c17907fd9832c8d45"
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