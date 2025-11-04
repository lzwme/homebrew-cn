class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.321.tar.gz"
  sha256 "fd7a20a58ea842e8d586748c493dfe5dd15b6ec49f5fd59d4f16a356998a9cc8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9efbdc7fcfb9a90ea867f5075eec465bacf86b43c6e1eee52c860a6da481122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9efbdc7fcfb9a90ea867f5075eec465bacf86b43c6e1eee52c860a6da481122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9efbdc7fcfb9a90ea867f5075eec465bacf86b43c6e1eee52c860a6da481122"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f98f5c6534e4d95a84db4e91f8b5069dbf8609376928fa13549047da639e701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ee7385130449040a572765d7b83cae79cc66f28fcdb13498b2c119321fb58cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7707479e88d683c6d0952f5a7bbf2e51b9ea5f8bbeb641aac1867e5f299a55c"
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