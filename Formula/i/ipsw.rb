class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.676.tar.gz"
  sha256 "e1c3ab00f1d6bf6085109009839e0db06a326282e020c67635a2464fc29f140e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7842ad6408dbeb45d7b7c2395fabe80b942c23e63af8f77ff6c77c16a9aa89f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c99409e564d88c3ebf46d323b9ec361211f6097cc595177e6f71e7aab5e19b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba77c6f99b07b8daff6c2539a7012f3d3d1de0385fa8bc6a69859c5f64dc11f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a2c64a049e755da4de83946e049a28a815df3f3aa93f80582a506e90f33b280"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f2c0349ba916239360851bd322e92408dc984130302d53124cefae4493fe72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81eaf16cdf69a5105297618e845d3af7310f8ccbcbfc03789ee0efae3d9ad646"
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