class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://ghfast.top/https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "77ec93afa5136f97b62777971634f0199b4a5db789ddd83ece45d2c6e5892d8f"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c988a43d66ee6da46c4441d4f3f9c147324b8a7a2375f1df436808aa07507839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c988a43d66ee6da46c4441d4f3f9c147324b8a7a2375f1df436808aa07507839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c988a43d66ee6da46c4441d4f3f9c147324b8a7a2375f1df436808aa07507839"
    sha256 cellar: :any_skip_relocation, sonoma:        "81acfdd8422dfe2cb8ebd1e10c96b887ed7df5fcc140c99deec72bb4d1d3df7d"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end