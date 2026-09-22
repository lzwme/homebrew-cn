class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.479.tar.gz"
  sha256 "4c13a5da41ddac6b4408fb4c2f33400774329326eb934b5b1b381da4b4a0a2e5"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88a9fef18afc24b3230a81a64a1a094a2a50e37d072799c99b8dc380eb1d171e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88a9fef18afc24b3230a81a64a1a094a2a50e37d072799c99b8dc380eb1d171e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88a9fef18afc24b3230a81a64a1a094a2a50e37d072799c99b8dc380eb1d171e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92839a7367f8c69c9c2b55d7f78153036bb3fef06fd8d0fd9ce41121e70a5397"
    sha256 cellar: :any,                 x86_64_linux:      "4fbb15c4306559cbf2a476b4025402bfd791fa423129533b22f35198cae7477a"
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