class Kerl < Formula
  desc "Easy building and installing of ErlangOTP instances"
  homepage "https:github.comkerlkerl"
  url "https:github.comkerlkerlarchiverefstags4.1.1.tar.gz"
  sha256 "b30d3e68f6af3cd2b51b9556eecf9203c4509ac5e3b1a62985b3df0309e04752"
  license "MIT"
  head "https:github.comkerlkerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb546efb10d0184bd5ab8204e33b0fd1ffc6ac108ba20c49f11636e860ceae17"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completionkerl"
    zsh_completion.install "zsh_completion_kerl"
  end

  test do
    system bin"kerl", "list", "releases"
  end
end