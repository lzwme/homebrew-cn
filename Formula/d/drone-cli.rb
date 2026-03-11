class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://ghfast.top/https://github.com/harness/drone-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "789cf088d76ec1e19c25e77f1a504cb3a603b772cc6fb19335452e9ae7044151"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bbe92d919f24bd17bc6150081e6d6d14bb55538bac20ddcb7ec8351415448b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbe92d919f24bd17bc6150081e6d6d14bb55538bac20ddcb7ec8351415448b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bbe92d919f24bd17bc6150081e6d6d14bb55538bac20ddcb7ec8351415448b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "553c5043ffbccd798bf7ae272f65b175bbcef6e879c0f66c5a2e3c9c7909d894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ed89c6356881d8c201965ed129782f6d1f4cd4d866d79cd71f5ae34c074d39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aeff93b304ed8ecf51189c9751a9578c5779ce5ae2ea796dd305f0a57402f75"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags:), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end