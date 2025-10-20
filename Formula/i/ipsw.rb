class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.630.tar.gz"
  sha256 "35919f309e5e36833243a3f7996157c857478f2684702601fa17d8cb7ea9525e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b95bcc85de8e1fe7c1376d77606ee1e73b1b9ad73a6bc9e7070cc13274e6bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac223e5602941f4e2b70303ac552b321578c72687272bf2a8517ed31c73f180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4effc2cf3814b831b3accfd87c22703569139d883a61b918cfccc9eff2f7db5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4895ee39a095d0977ade2d3ea2ffdde33804aa354d57523e609112099b704207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1446dc804f1fce06fa00dc745c8a9884abe47c6b9dfe6b1edff171df62d75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c527baeaaf96a0878b361a5650f8c654e2b25e08b10755685462317a50e564b3"
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