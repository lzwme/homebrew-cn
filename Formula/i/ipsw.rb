class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.692.tar.gz"
  sha256 "eddd377fc306e65e21726f7f4bc264e9d9db22a616b10d6d88807bd21d879d9f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0f729a7a5a8e6957ab2b7476b82e3ca53f3da364eac13fe5e2ae4cd37312c0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f9f5592bd47ee52d532a99222d0269b1ca23505096ceec77b002ea41f57a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094f87f4643578f027e37c7e02a9b62fdd1014bd3404362b4884f38b0ed9450e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d54219091ec723a4a5ae92c6589d95652368f7c4a527e129b8b07081647d85"
    sha256 cellar: :any,                 arm64_linux:   "c82960d30f48c43bd07ab8b3dbf5ceec89d1919ce7edf0bc9458d3f1a432a8ce"
    sha256 cellar: :any,                 x86_64_linux:  "cac17333fe91858561bd42ceb2c41d47619df4900a3060a253375df69886a541"
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