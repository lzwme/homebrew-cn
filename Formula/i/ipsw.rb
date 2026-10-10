class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.734.tar.gz"
  sha256 "d359ed3e4c6298a84abafb9d611a3d68d47ec38c5f8ed5c8823a8d4721d907b8"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82bf2e81da42838fa77689b4b2f0510c4262009672acd284aca1ae9981eeb745"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66e87dc078f96928c02c7805c81649b228703fdfa10aceb9333794e0bd12f1b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbca53e7e60ab3a746e2c613137017825dfab16f05a3955628feea4b8ef38e68"
    sha256 cellar: :any,                 arm64_linux:       "51dfbc05d34bfcb20295594feb5d8661f5c3210ddee7d39c7ad415a734cb76ff"
    sha256 cellar: :any,                 x86_64_linux:      "d20570e8ebc86b3b7f34cb8bb0d643d3615f775efccf0b568e7de88e9783614e"
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