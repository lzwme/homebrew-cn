class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.659.tar.gz"
  sha256 "b03101648b6b5defbc316956dd7309b88d8747533d1d430ddf366cec1861a81f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acd587326c8268f756978c78bce206ed0c5da562da0af4033563ee8dcea60d55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3903ae13010294af3d9a1cfa0abd9b6bba11246f4ff8c751db078bff88875f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9c555c44e5edfcff62cf85348b6dd538078fbdeee2a448cf4109b591aa99ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7778da4cac908c2356b38bea09fc994827e720bbe8dcf5591d908f1b2cec9826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6652278f6822c40755e065f5cd81a31ca68b0ca9747d94b8a24faaae8023f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf6a95cfdb7083e7943125a6cfcb0e302d10fc41597ab65a35f517d7a94c6bf"
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