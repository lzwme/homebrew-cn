class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.637.tar.gz"
  sha256 "32cc0793cfc44ca83aebab76e58c458e424fdb33aee2270e0df7740bcc343963"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ffaac448bbad35d60e0f33ed017590405c93153807178d6da35bf3305d6eb89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb101e413951e4b45e133b2b1971a84e0f4e819813f6e59942ed3c56eb1a0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396b0984c28b9934e45de373a186ce6d42079443639f87b73d6b79813e843d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "194b04eb251d377a93724a2fe505bd4648dc405440b409642cadad28ef6b16c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c53a36278da8492748d0bf505cbaf7796eccf67e8a5e6b80506d20d2545b986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1364e57f593bacd2bfae8d2967bddb609961bd23b8be937f9e91fc14b0497c69"
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