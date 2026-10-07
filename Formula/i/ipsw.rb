class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.732.tar.gz"
  sha256 "4e35020731fad75719fb2fa483806126529bdf422d7c88b73c2f40384708921d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1879749a6b7b055da72cc606884b7fa4bb90b176ddcb689d8d6362e911ff482"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "787aa33ca3abf36ea733d3ddc30e26a668558b81a827a2e357d9f5322bd6a344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b98a4b240ec5033b420b7d7faa40bdd0e26fae8e00cf5519aef30d669f57dd22"
    sha256 cellar: :any,                 arm64_linux:       "0987896a0dda114f7204e36a0221eab695d0009475366d0241bf7dc49558e7ee"
    sha256 cellar: :any,                 x86_64_linux:      "ac12a26c6be29e98ecf2751c5dccc0ae6530b75caf8bf704f7243182f50a8ab2"
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