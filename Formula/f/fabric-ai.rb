class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.374.tar.gz"
  sha256 "8fa7f24b9e29604947ab87e8f70c4e969da75d813dc27305b985d698b4529021"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef7d646943f10a50766622a6e30d32d65da18a6f2bd076d30f927a7acc30737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef7d646943f10a50766622a6e30d32d65da18a6f2bd076d30f927a7acc30737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef7d646943f10a50766622a6e30d32d65da18a6f2bd076d30f927a7acc30737"
    sha256 cellar: :any_skip_relocation, sonoma:        "51af73b38fdf3dea506c0b74899bc05c56eb4abb3283bcc5cbbc276ee84448ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5035157282411956c4d824b19565203f4be8406ddf90f40eb846d74a9dee6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a6a315e8c1b4c4285a585b15368eda04aa34de0d476a18d18e03d30eae8b99"
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