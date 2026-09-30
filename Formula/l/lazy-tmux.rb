class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://ghfast.top/https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "3e3fb7f96770bad75650fdab97c8e5bb09e6f565fa623feb696436f578662eb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f65c01306f71f1131bf97279835e7080bd6d7a5af02c073664455ef723a5e07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f65c01306f71f1131bf97279835e7080bd6d7a5af02c073664455ef723a5e07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f65c01306f71f1131bf97279835e7080bd6d7a5af02c073664455ef723a5e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29af34ffadd6af51e71631fed6fd26f1162d02bc63c1c9268c579d6fddb2b270"
    sha256 cellar: :any,                 x86_64_linux:      "7975b1533edbbfe4fa146c7803d3cfaaaa261774c2fc809503bf87650872f46b"
  end

  depends_on "go" => :build

  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/lazy-tmux"
  end

  test do
    config = testpath/"lazy-tmux.toml"
    ENV["LAZY_TMUX_CONFIG"] = config
    system bin/"lazy-tmux", "config", "gen"
    assert_match "# config source: #{config}\n", shell_output("#{bin}/lazy-tmux config show")
  end
end