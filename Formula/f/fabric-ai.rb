class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.439.tar.gz"
  sha256 "94c2dce4128091a2657620261e9430c97a2371f78e602cbfc63abf7f36f45405"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4946fbba56bb228add1ace642ee98d10682b3ca8940f300145fc3d8b304f8348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4946fbba56bb228add1ace642ee98d10682b3ca8940f300145fc3d8b304f8348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4946fbba56bb228add1ace642ee98d10682b3ca8940f300145fc3d8b304f8348"
    sha256 cellar: :any_skip_relocation, sonoma:        "7edca7e6fab36e776818bd06b28435ad85a8a7c58b63b584ca4f4b37163f906c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6593c6ae78201e2de83737dd0c35ca9e0f49dff6fc76224c2fcbde039fc775c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae90a88a9c9245edb9a75104c41c2be95585174157a1ba75479596746fccc7c"
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