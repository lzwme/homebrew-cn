class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://ghfast.top/https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "9c0457b0abf3eba9b8537cd8088a3bdfa456371b88b0d7156781aac4038aece2"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7034ce5de250f38fe1184baf787caeab0c6ab4d599a1d8264d254cf7f7353cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7034ce5de250f38fe1184baf787caeab0c6ab4d599a1d8264d254cf7f7353cde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7034ce5de250f38fe1184baf787caeab0c6ab4d599a1d8264d254cf7f7353cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d39918c2e47b69a1458f9e8ceb5d91e5277bfc0e4f7f33a2a18ca6b664b98d7"
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