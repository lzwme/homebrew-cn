class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.701.tar.gz"
  sha256 "545771b0c7ff0b48b0000a26f2c201e0c13149c10734ea41319630f693e08917"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23da82f82646a8c244345d65c56b8ac87b071eb6b50b49d65e387de0e3752fe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3921eec6a680b8e0ef36c00306f6c65b52b2ee06faba700d73700595d3dbff58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f1840c38f03e4b16cbf6a10e3d3d83b3fe7a6448d2857406aac4eebbbab80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf346da5f9ec903ea08765751fe39555dd5e3fb2780726e78e2fdafea10a5c0d"
    sha256 cellar: :any,                 arm64_linux:   "1a8464027daa523a3c1f09e140b2c7bac8f304eb0141a05960c82ba9cb79fa68"
    sha256 cellar: :any,                 x86_64_linux:  "2ab2a683811d3208ce650f7dff1d2dfeace04c0a262602e33be35d03a5a8db09"
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