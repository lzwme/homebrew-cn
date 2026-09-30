class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.729.tar.gz"
  sha256 "215c33754ac46c57d949b39bd6e578fdcd961aa89198379e2019993f50297efd"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c74502d9b4ea8faae217c4705ded238990f2f8b1a4dc6eb0f4e0706b88034cc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07cd3e9e2a1d4bb4da6b05949e4d183daa6d136e5e12f6fec79f14cae7b6446d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edd42f493fe849beb7b3de99f8e7689eb85a3dcfb2d6f65a2c6c4750250199f7"
    sha256 cellar: :any,                 arm64_linux:       "f43a62b9bdc6f4b4e5e33f15345cdabfbc9a518a0673aa5e7df6f3a8c29fd2fe"
    sha256 cellar: :any,                 x86_64_linux:      "4927f3fb8c7458ecd37fa4e444bb5744465619ea479470a6a3e98dd12c41ce52"
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