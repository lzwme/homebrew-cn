class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.399.tar.gz"
  sha256 "ec3ab869f7b8231f351d729b703f768733ca43389c29cb45e1e501bded5135c4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08171b26b5c3947e14ea8c296207880cef22a9229036b649e501a79b59220e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08171b26b5c3947e14ea8c296207880cef22a9229036b649e501a79b59220e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08171b26b5c3947e14ea8c296207880cef22a9229036b649e501a79b59220e09"
    sha256 cellar: :any_skip_relocation, sonoma:        "98af5fafcdf791aaf4d1ccd664b25c0c97d21507b73571121245e0085a4fe92a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d32b4fe7373f79e88a377067eb6b44666eab4df279fdfadf7977568ee1e9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f32c78ed5087f01e37b23660d0d3e9c8027c28b0fc92d2e3e9cc054e4a441c7"
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