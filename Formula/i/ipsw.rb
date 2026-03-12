class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.664.tar.gz"
  sha256 "815707bcd6d7c08c5f3f26e2def37f425f9d9ba48c5defef50d266db83b1ee99"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6bdcb8a4ae0c431c64b840164b926d28133336def97c6168b15c693a57100e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10814295a4080835af8545b7e5e136781d414cd86f735ac92f736d6cce3f43d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b4ccf4d0523451f6bb8a61fe32a4128e04a20fea8e9b4cb80fb4223af2f70e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b344866bed698ae502e6514d79a7232b76ad6c4411a5a9a2224a8ce7eaf33348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef31f8d270afad136eecfa44bcd4eea36e9b0c126ec853809c521a9fec86a2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31168529cdbdb7143ccbee990e64b888fe38832cab40a3cba24662d58148ede3"
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