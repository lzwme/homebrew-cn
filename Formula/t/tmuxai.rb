class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "20c649030acc47bc32d971396aa14c0e782821b4cd80c25a24d12565f0d0c9ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d7c8b277bbee2aaaaa558ff7c79fd7cc4dbc61582992f6162c0102cdf31523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d7c8b277bbee2aaaaa558ff7c79fd7cc4dbc61582992f6162c0102cdf31523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d7c8b277bbee2aaaaa558ff7c79fd7cc4dbc61582992f6162c0102cdf31523"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8ed3dffa06cbd3122aef50f4b832e922379da86f75e771dcea7c0d2fcf42495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7663ab5fd23373af36dbd45b0b2c04bd1dddf3fc1206d8ec75c655dcfcc11953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc76426b617f2cb528fd4ac47c491e28d7573ff6bd5b53c68783f8d487c9be78"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end