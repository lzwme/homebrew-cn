class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://ghfast.top/https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "a277f2b22a7a5deed580b9d946b3fbbab764dc1818e4fec2fb2b99955fb67af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75f5c0ae5689e00c85370defece3b317a4f75815746640fe4d92cb9bfcbf558d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75f5c0ae5689e00c85370defece3b317a4f75815746640fe4d92cb9bfcbf558d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75f5c0ae5689e00c85370defece3b317a4f75815746640fe4d92cb9bfcbf558d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e825cd872bd6890719ab44dd7abb121b0428d9fc60f672c04141933f6d74fa11"
    sha256 cellar: :any,                 x86_64_linux:      "d4ca09930b311b43f26826c8bfdb7a52b04a548474d4bb3b58689568ce008342"
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