class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.312.tar.gz"
  sha256 "d606d029cd97a354bcab9fde20e496f2263e872359d65e7a6f33340d4963cf95"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59321e58cf6045cbd694ea5524dc2fedb0753eae566b281c798dcc5906c585a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59321e58cf6045cbd694ea5524dc2fedb0753eae566b281c798dcc5906c585a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59321e58cf6045cbd694ea5524dc2fedb0753eae566b281c798dcc5906c585a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b652713091755f22fab3b94341c917f247ec5ada45567a3e03c13dcb1679374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7aa79cc4010dc99bc32e317f12491a26ec4528b46a1d41632ba2a706688d872"
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