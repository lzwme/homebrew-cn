class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.644.tar.gz"
  sha256 "0b34aea15edc95954c0bd53b95515543bec1a328b81b932cb4271e84d9643069"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e938cd2e33087b1bcec24725bad43d4ec69c311d0f72b87b32d2bcfae94a37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a024705ff2dab2d03c32d91606e1143cc0d5a0e8fa4ddfd77be76a6062322a82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07aaa549ad204650f840d7fedf0033ff7e809e1bc31d6284490c34bb4e01523"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d40b88cba3f063b7417f9e59ca857ca9313f2befeb00fc50951bc17a1cb26b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0028b537e958f90997a96f95110fb7b9638f06087d2dcc4f1c2614d518cd7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de88aaf8fce55981515460124b31db2465b492c174f58be3ea01cf361b325893"
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