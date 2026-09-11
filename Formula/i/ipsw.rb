class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.716.tar.gz"
  sha256 "ad6d128e439255ab586ba40c60dfeb257f880e0bd2b5089f3ce903cafc9f1b2c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d061129c434fe92f01488407c78c0cc8368b1085ffe8ca7de718f6761f29f21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e22e8b286855f0f486b062101177f8f1b5a869570b9515f70b9228ab9e700a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5686e7b091a52636b08919a70ecb9bccfa83936d456e9c5254ee5a08dbb06c57"
    sha256 cellar: :any,                 arm64_linux:       "b0db95b6ef4d3732a7cba8cda77f15972adf3610bae1ed16536fa69c6a3b02a3"
    sha256 cellar: :any,                 x86_64_linux:      "654ce8c19f437dc144985e5a21aa5cc02a996551b32c05e6300b10181761d670"
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