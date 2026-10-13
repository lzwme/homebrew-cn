class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.737.tar.gz"
  sha256 "51f05fac334b8435255cf0c081cb4266a2e2d941828544852f8999676f8d32de"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c1f5e1d53e50ad4f2fc93dd8dbf2648620604872cd137e5e5dbe8ff3fcf6171"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d961fb0e5ddbee3f2ea9b3b559a8c896c9a240c2cc652fd9ca4488934945171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa6296810a20673fb3f6e54133e1a142f9c1f33fae83c2a00c07bc8a1236e6a8"
    sha256 cellar: :any,                 arm64_linux:       "f713f0e07bffd8482f90daa51d15f05cd0ae1efc5c5b622be4da28a856332360"
    sha256 cellar: :any,                 x86_64_linux:      "a0d5c3dc2021dbf93aa042200af4904f9c74734dea0eb7b2c24678374da741d3"
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