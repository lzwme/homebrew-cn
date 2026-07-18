class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.704.tar.gz"
  sha256 "9e417f15f59e9be5558b2afffda7eba8af6d34dcb7ed5b388063ebe76f93a874"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f72961da557597b8f0647156c2ca17f963bdd14e822dbb8f71623b31bc901e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbfc942744da7d8b7cc3fe9d0f88cd3fe246526356a493dac28bca0f2989e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93af4a75d9e4d25e3edc3d97c99fc71d465c3084e02eae1932bd97fc04ba6001"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ed9b622ac48493395769f3fb6d2e97b8f970b5eeabda8545d373214a8e9caa"
    sha256 cellar: :any,                 arm64_linux:   "fd626fe0e9bb2cfae0db090cdb6b896778e9d688a6b8f3a5fd395ffd258642ed"
    sha256 cellar: :any,                 x86_64_linux:  "04ecac7f70a976abe1d7493df2728bc34a2c056ef4017ff4fddd09e4a3705ca1"
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