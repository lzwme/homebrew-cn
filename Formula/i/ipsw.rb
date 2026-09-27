class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.725.tar.gz"
  sha256 "c66f4ee7ab21768a91d36c3ab21eb59434e87e1bf51e699665e41512b9b74ddc"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f5ec76c301dde88227f4392ab8c4a0e3ea112810bda97a21f06fd0b2a6072ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e05ac5122d002a64864710d394598058789372952fbf9323cdf505e563a91d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e07f0c14ed607cfbcb33c153750941e614b19fedc5fc649b884a4defe3d55ba"
    sha256 cellar: :any,                 arm64_linux:       "a370d305c9ae089dda764212f4d227093531c820d6a45b26fcdb8f5007c893fc"
    sha256 cellar: :any,                 x86_64_linux:      "8ed627cef2dfb0c038dc4e0833ce418f46c183717d9ee6bef799a63b7be8687e"
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