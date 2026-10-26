class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.555.tar.gz"
  sha256 "d1d74800ba5c250a1523f250a1f62eaa3006e7733c23fea98c1465a05a24bc76"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d9d0aa765d6c2b285516f43aeab2ca190015b1c64f72d76dae555c72c6e577e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d9d0aa765d6c2b285516f43aeab2ca190015b1c64f72d76dae555c72c6e577e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d9d0aa765d6c2b285516f43aeab2ca190015b1c64f72d76dae555c72c6e577e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9013bbd7e3019beef5d1c59654d064f9b649fb497c6d8e1f3b59b5ae94e91733"
    sha256 cellar: :any,                 x86_64_linux:      "9c823c5d453c1bffc9a6fc042e87f994fe868dfd57dbf699f4a1e7ac9c7b010e"
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