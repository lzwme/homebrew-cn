class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.670.tar.gz"
  sha256 "629624e98ebcc4029774ec04a358fc898d797755fce047ef86ed211d1b6bab15"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ef99828007c264b2bf2cc507b2a0ef3631ccfdb353221618d2eb53e97bd7a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d008a78f16100edba2b70166bd388e21b8bd059be977342a448940a50371b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "940e7ede93075c26be41e43a72388fefbc249f6fcb272aebd4b05a10428cbfe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ded457cacc1890fd3b51e3e17c7b18f6874e5bd231b9805b9fd1ac814982c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013d2c3e9b0879740317866eb789bb0d1f1e8f9812fc539290f2b70d636e6f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bdddce1faeef4660207cb223419b7dea9cb8105d682208926ec5c73a00865b0"
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