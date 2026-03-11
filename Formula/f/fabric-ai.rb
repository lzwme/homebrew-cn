class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.434.tar.gz"
  sha256 "d1c0c7553ff5c1d2f77f8dd3db6562fc6619764817543a9231b135c141dbf999"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef1a3ede9b5b0850e0bb16cb4855ace1e3def6a31bc83a54e678cd4b7ee2ef4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef1a3ede9b5b0850e0bb16cb4855ace1e3def6a31bc83a54e678cd4b7ee2ef4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1a3ede9b5b0850e0bb16cb4855ace1e3def6a31bc83a54e678cd4b7ee2ef4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4801beda5ad0f4556ea27779e9c129827862e5d85573a8bb6f51ebdc57064580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a007dccb815da8219d478e3324f62e2d0173c471934230894223623aff66292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd25b0347b5796f2a55a1e34c88ae0fe2e8ae52ab5f3cc26149199f48142a7e1"
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