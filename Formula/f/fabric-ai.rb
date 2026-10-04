class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.507.tar.gz"
  sha256 "5d6e6e9b3cc437a2ae5ba42a6c6cf089d9324b723f86ddd68c9595c0987447d0"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c61c27de32af0e47a6c2e06e6f11dcd2f1664c1c8001008d517a42e1fdba41c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c61c27de32af0e47a6c2e06e6f11dcd2f1664c1c8001008d517a42e1fdba41c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c61c27de32af0e47a6c2e06e6f11dcd2f1664c1c8001008d517a42e1fdba41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da2dd88e746db3fb7973c8734e4948050604aceb31ba07f64fa50f2e5e3f1ac7"
    sha256 cellar: :any,                 x86_64_linux:      "ecb92632b1c9e7fd3170bb277780c6cba661c2459a22b2b038f8f1564d7fe12a"
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