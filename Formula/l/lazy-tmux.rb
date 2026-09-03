class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://ghfast.top/https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "213dc4002a22fad2e37d0805dad59aa76c47b838bcaeb6291c7b3860ee7eb92f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feb8c5636f0193fb767540e4ff67bd1146b2f587ecca8c0f0d865ec413ed7bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb8c5636f0193fb767540e4ff67bd1146b2f587ecca8c0f0d865ec413ed7bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb8c5636f0193fb767540e4ff67bd1146b2f587ecca8c0f0d865ec413ed7bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913801bcb292ae71b597d2d0a4615e5021c7998a2cb5b252ac054457d14df9f6"
    sha256 cellar: :any,                 x86_64_linux:  "678ffe78587f7144499d8ba1875d535b98844df649d2d1472f0e96460e382f3b"
  end

  depends_on "go" => :build

  depends_on "tmux"

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