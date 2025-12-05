class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.642.tar.gz"
  sha256 "d37ece2193bb3b83595809aa48a8b4305e73bef3668c10f0deb83708cf2588cd"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "162a53b4b28aa256281e153df14607259aa474b9645afd08ee1c4ad189f16d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd6cf3f73f751e7625c78da6d0a55fd37507b3eead93a4075558087c8a94f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48ff20f8506a180737b1e22c97f543e0e6a78b316afae14680619ff67d3c887"
    sha256 cellar: :any_skip_relocation, sonoma:        "c39449eee1aab3bd4c5ce9db289676c1711f807affd05b4c05d71a94f7b0e8d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820cd90d70215280887e09d5f450beaf1b27e6758efe9912dffbbbe5ec06809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef11178c573485e997b5611f39ac39120a1e7239c830da398bf3626825c166f"
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
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end