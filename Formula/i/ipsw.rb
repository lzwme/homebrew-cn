class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.703.tar.gz"
  sha256 "964e72e90a39e2d74e0e50c09cf43b644fcbd9e9e1404cf70bd529a158238088"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "294626cae6c33bf2b0f44a0e40712b32ac42299c40d6938bc68f7b229148086a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ce225aec4ea3c81a1d1abb5ccfb510a59cfc69c1bcb8406491b6412b364c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10e38ba9ad764ce4beb0af793982c314fa4fbb67e21d02b81011232795466af"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bfb0bbe3351e8535ffe63d637ee74a8973cc998c1b8b1f7c0710e07bab9a75"
    sha256 cellar: :any,                 arm64_linux:   "de7661443e45ac2e2c293fbfe06fccdd2f8d8100163e0945e0e6c8ef5167e4b3"
    sha256 cellar: :any,                 x86_64_linux:  "1fb7f65fc53ad2271088223a25317a3f363d4de5d9c44648c6e6a90b2244299c"
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