class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.515.tar.gz"
  sha256 "71c3f346628caa706b06ccc4d3ac6da5086c6e3b3a6958f532de6024a2558a93"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "321c15fb3a59a47f172ff0dc3deb38d2f3ceb6cffcc2b7ad7dc6fae5bc36a600"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "321c15fb3a59a47f172ff0dc3deb38d2f3ceb6cffcc2b7ad7dc6fae5bc36a600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "321c15fb3a59a47f172ff0dc3deb38d2f3ceb6cffcc2b7ad7dc6fae5bc36a600"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47a097c52916a9d60499e74e68827d7a296b891bd8bfd773d08c7d3ba02c3ce5"
    sha256 cellar: :any,                 x86_64_linux:      "dbf7159639628dbc012e9120c6068eb4338826a80b8ab6c5c6982b029ec0dad8"
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