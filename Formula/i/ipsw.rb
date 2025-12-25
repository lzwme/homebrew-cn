class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.647.tar.gz"
  sha256 "6d2d43269e93cfed3eea769650683e3a2b49aa27d3c2e09b7167553a4b561087"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea081b7ffb4e253df7a1c384c87ef94419e151b72c00d463ac4b91d742f615f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25976958ecbec860a59a82dd6178fd54bce9dcdaf395aaa0a7f477a2188ef64a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70020992054cf17aaca9387737024aeca8cf2632b99af6d34e3a811c0b450e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00a5b9a7419f20b2d86f99543612384bd2cdc4e2d3a53e44cc002a7f1a238a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4393b2005a2e3a3b896aaaed2c0b18518caaadf9ebd35a3d0e48c9c66556026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196b3f714e22ca427b4ecb6c51cf1e6188f39baa8639ba3779907a0dfdc88351"
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