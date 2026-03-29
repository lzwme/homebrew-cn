class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://ghfast.top/https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "6bf882f514ca1e040203dc461f1f54f02ba39a511dee050043cf7866ee1faf0b"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da86b83f75be39f0f7abf24db515c4dfbe7344de0ed8fd2307a4f45ba9a9c005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da86b83f75be39f0f7abf24db515c4dfbe7344de0ed8fd2307a4f45ba9a9c005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da86b83f75be39f0f7abf24db515c4dfbe7344de0ed8fd2307a4f45ba9a9c005"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6342a281acbd319d5cc75f3d7aa05f320b88e2fee218dcc98ec7601f396b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cf3a04c7ebe724265555e2d358be63cb09b9cff74c128062d52f114a37314e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0517f87e602abef027ffbdae378c45923440dc21dac4b565688d7d7ad456d9c8"
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