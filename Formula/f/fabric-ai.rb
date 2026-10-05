class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.511.tar.gz"
  sha256 "95846db1c99ceda0b61322746d5b59e2aa5ccc5c71c375c651dd0fec532820f3"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "558c20b06a8bf33ff0f7c3831bac59b05db9c5e6c4b32fe58d356c09ccad5f37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "558c20b06a8bf33ff0f7c3831bac59b05db9c5e6c4b32fe58d356c09ccad5f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "558c20b06a8bf33ff0f7c3831bac59b05db9c5e6c4b32fe58d356c09ccad5f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae476cf24a5d5e5b517638b7ef81d664ad2e1a24d5467489239e3f827a44d6b8"
    sha256 cellar: :any,                 x86_64_linux:      "331fc20fd2859bede27fa016fd0e9d372dd19fa5c32e1e135fe0d474a8aeea74"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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