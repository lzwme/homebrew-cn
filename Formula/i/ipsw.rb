class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.689.tar.gz"
  sha256 "9d2db8b2ff1d84600961f7378d87c831f352bddd4e9360f551f4903276894047"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0389b18449e037c7a7bf6b106fba3d3d05bc8c1dd814a14e2f4445d2d20b527b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce806db45790af1bf0dbaaacd885ba3f960f74eef4dc633fc4db1cd7bd05b0d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03775e29351c98967ff0540116675fe98ec34ba29a5673ea7ced0fb0d3545d5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e60330b970ae35348d918dce96b491aa709d8a30b7e1b54d1c7bf81dafb9736"
    sha256 cellar: :any,                 arm64_linux:   "b5e2ca66bf6cc2e20e8bb4ced929361957e4707afa5e029bf42950c908631235"
    sha256 cellar: :any,                 x86_64_linux:  "b917606cf68b2e6c692714da890649c28ff797d7c663e09df6caed569781232c"
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