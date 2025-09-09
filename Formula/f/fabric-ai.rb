class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.308.tar.gz"
  sha256 "c78b6a3a295265c78555f0b2396a9a329480cab5c8998d64f37f5fa802e62de2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e2af2b6d07e6cde3ecd19db5f8ab487c238b68704239ece1e9c8232f7ad223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e2af2b6d07e6cde3ecd19db5f8ab487c238b68704239ece1e9c8232f7ad223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9e2af2b6d07e6cde3ecd19db5f8ab487c238b68704239ece1e9c8232f7ad223"
    sha256 cellar: :any_skip_relocation, sonoma:        "150a8a1a406571f84701d55e666a3a79dff583d887d0b3bbcbed7105774f5355"
    sha256 cellar: :any_skip_relocation, ventura:       "150a8a1a406571f84701d55e666a3a79dff583d887d0b3bbcbed7105774f5355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abd6cfe3e47e7dab7677cc0e717435b0b141a899c42ab463b0783abcfcea1e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end