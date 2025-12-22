class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.646.tar.gz"
  sha256 "1bf1b03fe62c6eb9a5974cbbda77c4b7aa2fa31558c0b2d9c6dcca83683c9dc7"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85472396778977720f25246011acc6642321252fc4f61dec164ff7f72305cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7614a6818d0e599212e7e7f0b789638440a2543aa1f2b705ab5a9edf0eaefa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222ee866a92b18e805669b39f1a31dd1364d941b2e8642a538d4ac2bedf29dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43cd38778b51efdb8b43c181d001d3ce7589f3053f6d5cc1b75df8b4e64a6ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77a375b98d7aa5e15b3e1a4223cb29f4275c5022aad950b7c38f00a8014e1084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc17e612e9b3cfbca753e93af81574555180b1f7639be38fa9c9bd897e18b98c"
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