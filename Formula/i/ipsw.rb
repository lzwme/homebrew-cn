class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.699.tar.gz"
  sha256 "55bdf6ac383a015de5f24a95825e31ce64146cb8c8b4098a503c225cf52f1316"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b48ed93d439c79f1d469c109db5184b82d301da971a69e75aee909da4f330a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c656f0dfe4c1c0f504a133591f7c2e2fd2574fa5d0ca026bb426db3269fab794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e371ee40504aa8d99895f6cc40c06456e60a4d8f49c79528e6a1b2f860f24619"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c23f8f03ab5144443321c2d5175d393fa749cace075a8f410a0e209c4075653"
    sha256 cellar: :any,                 arm64_linux:   "5e6fcad2dc597cb14a2f96696664b02169ef703ab3c4f1f067998c2384926342"
    sha256 cellar: :any,                 x86_64_linux:  "807ea38eba12046ce5fe5a6e1c68e330d41bc31e7a87d6c2521522725cb0b500"
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