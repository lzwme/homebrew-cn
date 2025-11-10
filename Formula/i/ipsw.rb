class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.636.tar.gz"
  sha256 "77667d0aeb38f5be4255a650c9709de75b2e24d367dc5de7f9839bdd7634e586"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be523282f682791155911b194ccc2e207c54acbf3c30c6827bc0751cd48f20d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74deb071571fb6e1e2b386441e61c15a95e78a86349e9225d16d4297f7da88c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d26a33e82421fc2735fad2ef729f226378b7fc29dc84759709b6a0db3cb61b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f5573818f799078d9740d85e2320ff0135fd6b8f49a2dfd9ad5ebd933e5dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8d95c4824a1c54c3a1d2ee60cbbfb625ffc05b2e2b6d5e8416f4785e70a9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42836b32e4662a75303e17778766982a453a56719bf5f46ed43ad9add08987dc"
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