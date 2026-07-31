class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.466.tar.gz"
  sha256 "af4e289c365f824d3937cff64969c73e5bc9c84e04edcb46aa34f0b97791f2af"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed27de963037c685440c6d94877d06ae1e8b43bddc9fe58479341ee0165d713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed27de963037c685440c6d94877d06ae1e8b43bddc9fe58479341ee0165d713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fed27de963037c685440c6d94877d06ae1e8b43bddc9fe58479341ee0165d713"
    sha256 cellar: :any_skip_relocation, sonoma:        "e159c2267f9b1fc1d0aa830a08673500770412b59ce581e8119c2df380e50967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "309d35869d027dfc52ff7684f65b86c045cebd389d7992c3993ca170b0ec6a48"
    sha256 cellar: :any,                 x86_64_linux:  "5065b1a27c6e3d5316e6d3688576b3e27af1b214215b3d62a263b383e485e37d"
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