class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.731.tar.gz"
  sha256 "b90f4f389db2d524833ec96d1e8c4185d3cf4fdc09f84223f390b52de7cf7d38"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e4351ef9d70860d15a115cc80b8714b9e8aa768f4d5e838bb51215cc8bafca8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4eb3e1c3fb4a0d0bd7712f97a96dc864327bcd91df5929d9640d86dfd3fe627a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bbc0b5d52da99ba6ad0adbfaf6252cde24914e9f5a2c49bedbf70e03792159a"
    sha256 cellar: :any,                 arm64_linux:       "397d2cb4ad82cc8dc1178310921f7862baa5da45ccfb6a45dcf16330487c45c2"
    sha256 cellar: :any,                 x86_64_linux:      "a34b9118ddc5b14df1f0c8319e49095ee985dc380e1e40163b2062e2aebe9995"
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