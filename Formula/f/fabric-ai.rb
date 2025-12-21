class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.355.tar.gz"
  sha256 "7871e39d4035e09bec70c5017209bc5745d63e1eb31e231aa573520dae5b540e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ca89643ca1ded2471397d5d79dd1d505f1975a7a3d792e3dc750cf9d67b7aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca89643ca1ded2471397d5d79dd1d505f1975a7a3d792e3dc750cf9d67b7aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca89643ca1ded2471397d5d79dd1d505f1975a7a3d792e3dc750cf9d67b7aa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b90d9d8c10f2cce3aed6ac42c9d84881b6e3d5dc5c01630c4a1d587995fd03b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24c114a17da79bd82bd383772e32753bc231958031b9fbf789b270183d2fbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0281e4e353044e0fe603631fbbbec4d5979567a397c9ed1614997ceaf91fef6"
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