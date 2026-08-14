class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.708.tar.gz"
  sha256 "cedfb5cdccbe571e89a6095fc83b9c83a3d903992705724ce57d7b0d08090d31"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37698b22689acd4263b938c63af7d25b40436bdb9a7f0e2fcc569c6bc66c8ce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f4fcc3522dc553805404d66a760c06e5d716bc4270589720f4b57f417f2237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2dcf2a86f3abcb0adbc1a3136bd2a678357308309b9fc79713bd7cf94c6411"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf2c3328b12995ae1cc40c45514fb3b06a340ac138322ff23a3408b89f46b3fe"
    sha256 cellar: :any,                 arm64_linux:   "4f79c45871db07882dd25058407cdea2225308bd902bc1f3213e113169c61100"
    sha256 cellar: :any,                 x86_64_linux:  "8669b6188778e32c93c95ca94efc1b7830b6cf0193752c1ab3f93ccaa6e304a0"
  end

  depends_on "go" => :build

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