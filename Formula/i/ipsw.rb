class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.658.tar.gz"
  sha256 "796d22f2fffe69ad978cba6f7982d6cde487597169cc933cb5289b9d5bb6aa55"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02c61f34ea79676d1316a17ea6b00167e55a830a2c77e72df424617dff69bd71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893d96f358826f5431deb1b183465c6cae6cca18c17077efa9d90a3d14ebb787"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc964c86adf538c84ba35fc0479e78521d247bd5cc097b1028b07d29cb0be50"
    sha256 cellar: :any_skip_relocation, sonoma:        "506770021acad7de2e1118978a5c3d58728735dda9e9f2370adedd24dcaf18c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33bf302cc7ae530fc31d70ab76beeaef795d94960c5e2dae6b4939823bbc407d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c0f4bdf07f86770c95c4b3c14ca12f94a4efe482c9d830c6fde44d07973f3d"
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