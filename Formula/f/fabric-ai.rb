class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.423.tar.gz"
  sha256 "616e44b00f279afcc0ceb711f868c1a531073a94e87abf0dcc2d4ef991a07d7c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b47abcb777b2a7c3e0f8c6ad408de0e88bdd052c11681ff7287b14bb9697a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47abcb777b2a7c3e0f8c6ad408de0e88bdd052c11681ff7287b14bb9697a8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47abcb777b2a7c3e0f8c6ad408de0e88bdd052c11681ff7287b14bb9697a8f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5fe5f1e1ec916d3babd452448ca78c01cd2617dd050356a4a9d6d2bd468652a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcfb82a02c081d6f185e10193daca8e832dfef268d3f574c34baf718954ce070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24af0712eb50dff7853428113752f43ce6d733c48515c7effe19a1af85e8213e"
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