class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.458.tar.gz"
  sha256 "1817a684fb330458b636dfc9bed631df2f83e07a321650b295251fe116c50b28"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7822fb6fd64412d2d56d6dbc3fab0794c609ba07d13f9547456817f4ebffcb7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7822fb6fd64412d2d56d6dbc3fab0794c609ba07d13f9547456817f4ebffcb7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7822fb6fd64412d2d56d6dbc3fab0794c609ba07d13f9547456817f4ebffcb7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e1e28bd35a1055a8e294c92d615e2f9ab55af975dc446d19962ab096f57ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6300c510c7cc1b7d4e5f5812fe45a95d55767ad07d5914f334c98737b800b978"
    sha256 cellar: :any,                 x86_64_linux:  "0eafecbc35f398e300277589a87827349f2b28205d6e2bf4e3e31e47f5fa9189"
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