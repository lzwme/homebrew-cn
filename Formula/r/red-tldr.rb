class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://ghfast.top/https://github.com/Rvn0xsy/red-tldr/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "823a2faa8f0259c093284a5609c980e2e836cbb31b515454cb5192701418441a"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81973eb326023f9ff32b1adbf523013bc59ec1552cc794a67d3970e4ccbe35f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81973eb326023f9ff32b1adbf523013bc59ec1552cc794a67d3970e4ccbe35f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81973eb326023f9ff32b1adbf523013bc59ec1552cc794a67d3970e4ccbe35f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b97908983365601abe6511e29e92281306984911972b494d654d2d1284336021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83d91b69685d26318c3c8498957abd433fa3d7d7ecb7cdae398bf5969118d63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da5ac0199cdec6df642a32b0687950c1b13662a8304b7243313fe5c54b476ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end