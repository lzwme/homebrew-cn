class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.415.tar.gz"
  sha256 "87c4f0b9ea8d919a32f15591c905cd158c3009e7885bfc7cee382693d1c707e9"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e416c21b008f03a5a044890ab86d138830d4f560cc2d021afb4aa46962b7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e416c21b008f03a5a044890ab86d138830d4f560cc2d021afb4aa46962b7f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e416c21b008f03a5a044890ab86d138830d4f560cc2d021afb4aa46962b7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2390fba770792b5d7efd8de469d28cbe716e4e0af2cc12b48e925434a13b3bd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e82be26d9c5b83ddf3377b7cb6959040ef5ac043643f9b3f3b410bfb4a4932e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8c193c934ec845e058a6095d33b945bcc6644b4aba08bcb60f1b90b1e66895"
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