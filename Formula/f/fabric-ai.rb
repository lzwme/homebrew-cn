class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.331.tar.gz"
  sha256 "9babfd77a0e123a71b6f8ec340cc2ed5da9b4243d00e720b7a1b051c4a356719"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c4cbe14ab3b5e619ec2b86a1a73be6b9070d4508ce34501f603f7d50fef9c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c4cbe14ab3b5e619ec2b86a1a73be6b9070d4508ce34501f603f7d50fef9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c4cbe14ab3b5e619ec2b86a1a73be6b9070d4508ce34501f603f7d50fef9c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "044b5959ab01946b573dce388c7ad32038c3aefc421f7262fbf67caa12f15089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb4010fa5aff60bdd4da5f5e024094928df00777b14acd0aaf33523de7ff285c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78214864689ceaf6a066d3f9c5b15c04bdadf9539624eeb3b49cbd936285801"
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