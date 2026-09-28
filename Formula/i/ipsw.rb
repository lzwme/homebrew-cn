class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.728.tar.gz"
  sha256 "14c5511932a5a0e79e194c3da57b13343dd94484c7f08f96a19b19d6d1bc5282"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00942d4ee461fd87652bdeb793bcaf9fefe7d186ae06769055704f247c57a5dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "487f1879f5ef5ead02dcd4311a997da6f00eaf04acb91e3d85e3500212f4e507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22b36fc3ec6c34b60365f2f5935a109c8d771ec183237ba096198f8bc7a26f90"
    sha256 cellar: :any,                 arm64_linux:       "437a3a1f494430ea9ea9df4e84b820e4dfe546a907665f0896fdef07152a2705"
    sha256 cellar: :any,                 x86_64_linux:      "29ce345680a1d1d5dd62e8e51cf187115ce7c1d816152b608b0ec30a232539db"
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