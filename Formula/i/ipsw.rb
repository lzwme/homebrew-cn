class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.722.tar.gz"
  sha256 "13ae455fa5219e754bcc01f9f99e272a4d6b0511b2356be8b7beb19e9fe2935b"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74c3e68c8c37eb0dd346b82a27b17a91e0e8dfc8e4ba9829cfd9a594bdde605c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85190a9ac87b1494708781edbf764e67381635a5bd3b1d5fef7ac11ab16a5894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd8658328cc83a0bb6d0610d3a16f43074b8bc89254d64a258fabd4f6106e1a9"
    sha256 cellar: :any,                 arm64_linux:       "86f21ead7a4b96af44f30d8646dd2caad63a9ea7ea9e51e9b726232d79d8bfe2"
    sha256 cellar: :any,                 x86_64_linux:      "64915b9f6e38dd0837006217c54f9ea9d4e7ae8bf1ef044c24d3a01d45df895c"
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