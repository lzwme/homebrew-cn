class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://ghfast.top/https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "67696e0d13d22f33ed00b603ce889616e504e2b03adb3e9f75d1ea212f2f0e73"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bd2d0ba51db225cfe2a18c63a8b9c2472876fd08340cfa5bba2ca40c8ddd725"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd2d0ba51db225cfe2a18c63a8b9c2472876fd08340cfa5bba2ca40c8ddd725"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd2d0ba51db225cfe2a18c63a8b9c2472876fd08340cfa5bba2ca40c8ddd725"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a1c5c958eac29896c7913a3c53e4c25650d5257661abbec81b8932b7d3fad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98f135bd52f9c6884626ad740e38570efeb7116de9debe82ce2b12f62c34254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bfa0090e180282f66d8016b9ea9ad1c712d5cbbe90148ae4b8ae87392d02102"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENTS.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end