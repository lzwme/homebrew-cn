class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://ghfast.top/https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d3f8ab405fe69e75e349d93adfc4c926506d5405f15941092c788a789af8e6c4"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c9fbd6096366aa3db40f73eb6dde7bf4003850928430b64bd2cb4f7552475f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c9fbd6096366aa3db40f73eb6dde7bf4003850928430b64bd2cb4f7552475f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c9fbd6096366aa3db40f73eb6dde7bf4003850928430b64bd2cb4f7552475f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20390f1e36f810e5aaed10d553d32864be44a04408eb43c2a0cf25a6487cdd89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "015aa68aee862b394c550efe74200db02f51209a85ea3d12a205a5e2e18c47aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903dc4403315d311eb7fb7b16315823f846f9b89ee5153ae24123031f6a0b65f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{time.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "network_interface does not exist", output
  end
end