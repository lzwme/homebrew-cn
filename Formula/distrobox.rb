class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://ghproxy.com/https://github.com/89luca89/distrobox/archive/refs/tags/1.5.0.1.tar.gz"
  sha256 "72d7896ac9b669622a74d683c9f1d4c6343dfe7f6f4dc6cb4eefee6f375fadd6"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bdd803bddf00022c52b3958586ca4b41bc84a5241674d7ab45c95c16acb94328"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end