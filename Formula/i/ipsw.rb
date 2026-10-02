class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.730.tar.gz"
  sha256 "d491a9764e801f9abde7c99627987e5a376e4f5a5aea167f7aac8e4e80ecdec6"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce0966023e8b25576f6737b0def1b7c3e57605e2dbbb7ed2ebda153ca160512d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd27e99b0dfcbd00cd2a508392d03f5e0a3aa758b7da2f161db077b311e6499d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0759af119b080188e03567f278e6cb01e776c1340b1c5e1fcad7aadd6783aafa"
    sha256 cellar: :any,                 arm64_linux:       "f85f00c14b58fb8ae6a623ace816e31d806d150fb8f574ce91fcac84900b021d"
    sha256 cellar: :any,                 x86_64_linux:      "bdefd9f76ad3aaa9d38b4cea2e6120dc481b6181f2df364e81626e008055504b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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