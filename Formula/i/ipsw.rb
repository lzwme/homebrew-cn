class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.674.tar.gz"
  sha256 "26f03acc4152804932ff10e76d8eb8def4dbc1b99c7dc702e67b4f8336170c9e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3b0e819e34224d73183436c8f82b403f5825477cb00893010154fa22c82bab5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c7aa73a0bce1f724fa4fdd36042cd675b6501e3286462dd444596f8d5359fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd3109d896db774abe09905ff5b3ee9a4fec1abe8cd76cbe37a295fc4ff47abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3c4b09ae9ad35f88deadeb4d642ffd1044d3c16454211f40e1fdfd42f603d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e5e5445861797293f07b7f407372c32a3dfbc8939b9599f56522cfdfdab219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8990329f58b0c61613c391e61e01f966a83c0fddce863570682db7ad8f20bc77"
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