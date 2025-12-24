class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.360.tar.gz"
  sha256 "0fabec2ffbef6e338e485e21de10629d4590d581512b0f1e6d4f8b8cc5d88259"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b18611a2c62bf02a2fffc821fdffd683efbc44b9c295cde992e78b36234c4146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18611a2c62bf02a2fffc821fdffd683efbc44b9c295cde992e78b36234c4146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b18611a2c62bf02a2fffc821fdffd683efbc44b9c295cde992e78b36234c4146"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce60215559b7640c8e957b27518aa780038d943716241c1c62444319fb599ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1458e64f5dbdf96c24f40ea9513bc04af48075264185de3b3eac63caf4b6653a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a25f20ceeddacea65325488ebb163d0fa1ad2f342c0db01b207347238f82b997"
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