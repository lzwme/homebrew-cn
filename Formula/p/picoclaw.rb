class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://ghfast.top/https://github.com/sipeed/picoclaw/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "973faa529b144954a2a8d2212b80895641676ff0736c1488d0ad1fd70793fe53"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c524b0aa33362eec4bf9146bbaf872a24d37ad9c00eb419c83842bbc2bb2e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c524b0aa33362eec4bf9146bbaf872a24d37ad9c00eb419c83842bbc2bb2e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c524b0aa33362eec4bf9146bbaf872a24d37ad9c00eb419c83842bbc2bb2e4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e27dff121e0b521d26dc1112f42866a51762ecb19ca3bbe94ffd29662a8923d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf77007f8636729dcde749be51c1221c9d3fd1ddc28d4360c9ee6a6289e7d5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf1686cbee5d619b0225a0c20b72e7c158fa8f5ddaf0864f73ea37dbcd7a4ea"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw"

    ldflags = "-s -w -X main.version=#{version}"
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
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end