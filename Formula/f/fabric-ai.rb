class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.467.tar.gz"
  sha256 "f25b93c4d9b6cd612806b91d64fd0c0c764edfedbea3e14e280aea8d15a1a38b"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7f66104f195d08ce7091b5f026a4e4427809333fc9e836f7c93c8ddd10ed52c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f66104f195d08ce7091b5f026a4e4427809333fc9e836f7c93c8ddd10ed52c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f66104f195d08ce7091b5f026a4e4427809333fc9e836f7c93c8ddd10ed52c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb928472cf8f89349e566672f96bdd3748eb192b81a4ec8bde3926f939f6c67e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3393a3549e5efc9bee936b29810bae2006b1b94bcdaf7bee8838a0359728e68a"
    sha256 cellar: :any,                 x86_64_linux:  "e542b58d42f6979135c4c7ef7e8bf8b1130ca32470c40aa680b4961f1745f518"
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