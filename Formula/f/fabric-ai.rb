class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.323.tar.gz"
  sha256 "989f4c0c3c75e2da333f7bf1070d09950f5d065e597c7ebb996e497d3aa6eb79"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ac1b3ea26fcc77c422b2d0356d02e5b4ed07c449f905978c0c9dcf33af885b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ac1b3ea26fcc77c422b2d0356d02e5b4ed07c449f905978c0c9dcf33af885b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ac1b3ea26fcc77c422b2d0356d02e5b4ed07c449f905978c0c9dcf33af885b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb8d0367e1faa9c77ca7283a7882e794d8aadd9cb2040b712f00c934bd5f48e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034728f83df449c13f824d6a7bf565b980d121ab0bf3a353ac5d928e12cd1e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfbf14585f93a26851a7f3684077158609cb83c431d67c1c6b62caa943c1b46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
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