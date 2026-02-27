class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://ghfast.top/https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d88a4e289904463ff087d322b549343773098354b80faf71445a329dc5c0c2e6"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56d7196f0eb86288e35a02af1f1a2ec65d5d1d2afd616fd1fe111ef10f087429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995a70aea198182f13c3c09dec2ffc0d70136a4e5a308290e856ed84c0998a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be5fba2f3f86e19e46d080c000a481c8a073a465b81e7b20b7e083bccef342c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c1aa09e4f8611c016a25bf4213bb8ef9d00b490888f7259fabd96c2ee3551bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb5459b9f3509c10ebe08fbd145a7252a024391b2e4f62e9b8391e9b4fb915a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70cf326907716302aae1d0db3521d0be3f4dc1df3430353f99b3a62096c2bc91"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end