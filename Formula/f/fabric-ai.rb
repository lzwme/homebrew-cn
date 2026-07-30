class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.465.tar.gz"
  sha256 "0950ee0a7488739692527fdf0dfb4ca42612a6f274b253158f7a8a2236342f5e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17b1bbf631b14b9c9dabcb1b6840c29b87890835ed4502319c920b74cd79198b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b1bbf631b14b9c9dabcb1b6840c29b87890835ed4502319c920b74cd79198b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b1bbf631b14b9c9dabcb1b6840c29b87890835ed4502319c920b74cd79198b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6222e4b7d78802c193ee82849184558a0b3ed321df76c78a4effd131cd81ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6038df445a769805cd6f9e8efad716e7e3df4f73ce421e682e9f335b11e6693f"
    sha256 cellar: :any,                 x86_64_linux:  "db8a22eb21bbe82b9ee65c7ac591be56c08e51f8a8e77a1d5432b18121d10a8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end