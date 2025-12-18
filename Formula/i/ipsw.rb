class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.645.tar.gz"
  sha256 "3bb811f6a489f5aa583c654298dbb6c5e786a5e10484c9e06e437ed25d2c16ce"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "832b0d91c8d11e09ee8b1fbf75f7153d032255e4c75c2e3e3c2b6287dcd96e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa427c0c4789613ac989c464e09c196cba79a9815111c76179a83d7205255761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eab8794f857426d82ee14d6cd0b749b92253463b63ed88edeb6a6e06bfbb76d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb17f11e95c945539266b7469f4445c71fd8daee2b783d44a28e561a24fbef92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21ce9f283f983b97859c9d32426eb36cda3137cfc0e7d52a6c5bf66ae6f7cd75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2eb39d0940ce0ea793e91e0f25377a10a5b3189d4d1a163563ac9058058f501"
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