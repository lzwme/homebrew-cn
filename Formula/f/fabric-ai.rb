class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.519.tar.gz"
  sha256 "07adc00f46c003c6c737e534c4ef1e44f6091bd63268fd1efd5a6603acf03627"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "901cd113c9d8768ceb6898da3977853229928820d090fad24a94e63ca53b4509"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "901cd113c9d8768ceb6898da3977853229928820d090fad24a94e63ca53b4509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "901cd113c9d8768ceb6898da3977853229928820d090fad24a94e63ca53b4509"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7661d64acaed9b90fd3e9b5902f8c36197d65607e7eb56c12797c14a1f37523f"
    sha256 cellar: :any,                 x86_64_linux:      "7cb217459b93ce0f65f571bbca2b612132603719eb5583804ba9f9615ef28954"
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