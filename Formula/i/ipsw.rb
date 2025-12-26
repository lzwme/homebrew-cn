class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.647.tar.gz"
  sha256 "6d2d43269e93cfed3eea769650683e3a2b49aa27d3c2e09b7167553a4b561087"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b199e89fe5f9389ef8c15400b569eedc7cff4a5a44e89aaa06ffb9f035d4e703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f3117a2d5f657fd16ce16cdb9d26c7d0f51ec675f87490bbe9cfdca75aa194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7482e5bff82b3782fb11797e6c7e9c3ecad9bb35b6555dc32ddea964e6daae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3275ef5e79cdf881ccc07885fc79e86f178e56f68a7899f90349913ef71017d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ddf341f8e1391d5b17ac1d66a66f03be7b514f49bf0e61075dba7caf8bb3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83bbbe218794e56edbdec66bbf760070a467e0b4cb7bee8ecbcf2415a2378a34"
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