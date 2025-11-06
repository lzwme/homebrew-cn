class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.635.tar.gz"
  sha256 "8f5a2e485332421d7d8aeb9a93545ee8416bf1dfd4e2a80f39265b1eaec86556"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38015c834658035839ba01735d3afb540b67b4cb9623f508feda5ac0595de054"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa3dc8ab87cd9e90b1c06461bfa0d5744c162563fb4ff8ffbd3fa9de47e823b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72440208e8bd9ee46439e17cedf7a2a8b79e1321176a91f076a6096b28e3eff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e84c4714aa39da61ad7d7dbd49ba76716453d852b0e824bc1e09ac975d8cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d64ae3e01102b097c64b3da16b9c7a446b7b931a5e69359c7dbd012226a1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa9712f2ad1d5439ae3b511ee7d0e2d6b249eb61d49abc7cfc3d163344968d3"
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