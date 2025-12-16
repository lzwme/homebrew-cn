class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.345.tar.gz"
  sha256 "0b650da8f9cdbad5c87bdee809ca61fbd0a7d96d5b1c9bfb70e0d0f0d5303c92"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69483e03b394b9a23b1e27b1fa4576f0f4c5a63641b11648b6888d4694865242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69483e03b394b9a23b1e27b1fa4576f0f4c5a63641b11648b6888d4694865242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69483e03b394b9a23b1e27b1fa4576f0f4c5a63641b11648b6888d4694865242"
    sha256 cellar: :any_skip_relocation, sonoma:        "728b5485c050815b619fabbf10cd74bae3b26ed600744fd952d3a9a549c3a4ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a1697fae75dcc398fbfaf1ce6d7be6b85683d01c91fc35fa6ff72ea85957e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05624647a0039e08681abc1702898ff54f1f69e8dc0fc32880815d92e46f24ae"
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