class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.663.tar.gz"
  sha256 "0276ebdbfd078e8495796985e9010af45feb3b30c595a0554b638333380f8d67"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a76549d2df2f00bc085724e5987df5a65df2035b6ec377aae6bc779502f6200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3113bab42535a5cd9457a338d164c1f745e82c38d44fdca01344d8c52b1b1fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b51543f15c12a4e39d4e05bd425ae2535edbca00279b958bbc75a052266beb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4458fa9e5e002ac02512be55f85b50d86db5aabbf1d3f9a2fa0183ef0fd19db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3049814ebcea5ac4edfb6aa75d5a07834a467e0218b6765cda5dde02d0da56c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22702ef9326fb8a14d786c74bd7f8620e17882d681c1d376935bbebcce40cfe"
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