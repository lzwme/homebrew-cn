class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.654.tar.gz"
  sha256 "db1233ba5f11ecb12f13c7e9494d1fa4083f6324e476bf043524eb94b19163af"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe0dafd0d3c58919019fc9b61b91f429e3bf41091a11e34788e54f1e493f14a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b990863ee1f03327d5f0c10a7a91a90d365d71441672cced8ee98e41d2c08c48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c7a52cdf7d80b18639181fd8db9672f0f0e25d3d4ef33af75ce0b33285765b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8debc27e6c89be04f1175ad58a6fbeb214f4ab7c8a8af0decb98f6e58daf0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edac9f143450b1de86f979c81c8df4215665d4496018bdbfb859ccdb412fc3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c2462a03df4ade89408377afb5a62519a4aa8082669bf3d43da5aae65b5e692"
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