class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://ghproxy.com/https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.7.tar.gz"
  sha256 "9438261ef39fb3785a21edc00b756a9866e44ee373326f0269dc066c9a22ead9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fcbf041c094d1031dbc16f7937fae86b5773a1fc66b786f4b712fd42f3e9ca8"
  end

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output("#{bin}/ugit")
  end
end