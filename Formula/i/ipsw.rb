class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.721.tar.gz"
  sha256 "2f52dd05913fd616ffad0b53d56b3ce1f228e6b3824a47c71458d0f78ad12b30"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1a40f95d341c51d6da073ce4adae9d539d236356fc7594bc70059457fe9ae21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2623e4593e6e5c02dc27546764f77dd28e83db8ac9979ef900970b41cbb8bc64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a8a3729bf550fc39c929e2ea73a966dab8a8bd67189cb1b324517472ddd8aaa"
    sha256 cellar: :any,                 arm64_linux:       "d1315fcd74b911261506dcbdb6e0581fb76a8e5bec5921429f1baf3749df9663"
    sha256 cellar: :any,                 x86_64_linux:      "9da19fb3802c0a77846923fe92fd165c46ec9cdd607b24ae1547cc85e937f23c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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