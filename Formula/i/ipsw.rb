class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.643.tar.gz"
  sha256 "983ce6179ef5c001a31cbfe8ea93282d38436021edd9c970a56780033b568a9e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20c7a1e3b07eec616aee0b30f357c39b2bb43b29f4cf1327552cbb73f310fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c26d3da5d9c3a85e4a5369179745531a33a9a031ebbc2a775de5ec1186fe37ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed19948cc684f5314e1c32a276c769e3a034b94348cc90b7f2b2f363550d50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f427656214160aef8af835df7120e9e8a1a277a8e16d63d6267cd5bd57e5e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac79aa29daaacfb31c9027d532a1984a0ed150d050b6133791e48447eb7ee31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad178b6c1503cd11137f335ddb07a78eb2e3f7a320974449bda154b5e5d366f"
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