class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.666.tar.gz"
  sha256 "728bd2d44b77ddaeca131d8b743b61698e3e64c0689b90339f6ebe1034ae98d8"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a0fd428634c183d45e771638973be5d0214a4a43f0f7e4862ca790b1f6a40d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af329f8c58670bb94f94ab10d39772a57094fa4116c91e689ec253a52802d45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba920e017937cc7d10c1c7423e15a6413b8fa7bb51e06597eb410bb117c7336"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58fa60b0d02fc665464fb64d4cb2d2b65cb756108f111449808b13af97f3263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854d22ccbe003c5dfccd77d806682abf08907afc0a057ef42b781db5d3d56221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ead00b4dda0c2cd997b514e6df39a07568c353a6f98296d6082950cea7fc244"
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