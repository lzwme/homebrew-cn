class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.367.tar.gz"
  sha256 "feb6a21ea8bf91d26c55bd5ca5462dccad4b416e6c455783674b29f94b5a6bee"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28424e5eb156c28d7da3523a2774ac319f2e31e6032c0e39f93087db47a67cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c28424e5eb156c28d7da3523a2774ac319f2e31e6032c0e39f93087db47a67cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c28424e5eb156c28d7da3523a2774ac319f2e31e6032c0e39f93087db47a67cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86e313f882d6eb8f78697f8ad612e2b3ce0636548a986b4269ba40a3f5d6a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ad005f380668fb51893f5d1754c06f392df4c415b3cdd22d6f9318353b7ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "badffd50e510854899dd2f589a0074785ef97b99b1c668b64a4e6a896e445c1c"
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