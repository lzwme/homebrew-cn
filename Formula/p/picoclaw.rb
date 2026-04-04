class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://ghfast.top/https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "33f8a6346a90e9e52635add04788f6a3f787ae45248e4fecd548cd181bf88087"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf00a587c66a8589e857c7393dced3b5d88e48cec84e35d6fe50f5c67f638b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf00a587c66a8589e857c7393dced3b5d88e48cec84e35d6fe50f5c67f638b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf00a587c66a8589e857c7393dced3b5d88e48cec84e35d6fe50f5c67f638b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "103782eb50ae82b6fdab6b28c09dd61b8bedf3b4b0e1139591c1f8b07f1f67b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c2b42610008e3398419803f06ca6bc109f77268286ffe5c533c6434685b3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3191d33053b620c1a6e7676aa60f60b3e8d3dd6fe948216c2c80bd730b37639"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    tags = "goolm,stdjson"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/picoclaw"
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
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end