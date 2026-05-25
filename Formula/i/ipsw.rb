class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.685.tar.gz"
  sha256 "a9de2db8295382e659943c9dc9eb6b06c8d80b1399c0045b1ab59ee490bbd767"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "511a19f0c8fef584a036e97f05fbe12faf8581de242ff8d7f5b9129f03db8fc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0fe68161e63432fec3b78179d27f3711dcb427e02966fed18dee7967e30707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f46e22f059eb4bc7fc6f8b7e387130b8863a155e06a9f5b984b814707d5c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a8dc34cd457dd926bdf5d1e27648006cb5bdd70f38e470afe566f677d5d3fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c76a20255f6dca634857e271cce2008836f1dfb5863254d723caa1948f0c768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c82a863c28044c85c2918ed6e0dc4adcc80b3db27f7e42152048c3da5daac61b"
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