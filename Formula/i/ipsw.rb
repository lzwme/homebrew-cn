class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.675.tar.gz"
  sha256 "090748cedd4c9d35aa8e6ce5961cb76f2851ab6ad4e4789652d26305e44d9e07"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a97c8cb569ec291d0b676400abe2f1f1f057a5c1e2b968bf644da3928ce2ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e2d1fd90a6d698110d91506f69083d0cce194786df7faba75c25aa8c169677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef69502bb6d5413d8613f146da033af3feb86a3f89ed5c289d8f4fd6fa0f5a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "e684c2faa03d91f4b47c63043f19398a1a772aca0b8df2a22c2600a73bdd5625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11131f596d8743f7bc045284ecbe80f7363a19038245b2e27bd62397afe5d31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358969b38c645ce6739e959cd2db858772f75f3f3c39c2a2b2b183d97318dda0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end