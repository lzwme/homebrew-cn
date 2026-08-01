class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.706.tar.gz"
  sha256 "348bdc44d3cab96b11c1693be259a2f8e79912ed3232f624ea8c1398b3f9b1af"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d98346cbb8dd7078568d4b3c1d055d7883f0915ef84203bfb06bf286160acfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4254f57387e95e59e258ab3c255b771ba8be7bb4ef5264ae8eca30fee756f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7bfe5a0b4a7410375e5f8ee940c7b6dc03f0252f867ba59639f6498351e00d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e515cf0a6df73d96d7030e11233603fe328c99f0c3b265d70d767e69139198e"
    sha256 cellar: :any,                 arm64_linux:   "5ea93817e0d34cb5a2873fdb66deb37c8ee6dfacc2baf7945ab9e9284084c7b1"
    sha256 cellar: :any,                 x86_64_linux:  "3525ad13c46babe31a27df025b0d95c8badf47e1204573a875f8556c892b016a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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