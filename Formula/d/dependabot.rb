class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "bb0b0c82ec8ff4b951983848c024cc7ea602177d95af7fc57a8da4ebc717b8af"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6b30341a78b47c310bce433dc77361b47d788154ff83e257859fbb45f72f679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b30341a78b47c310bce433dc77361b47d788154ff83e257859fbb45f72f679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b30341a78b47c310bce433dc77361b47d788154ff83e257859fbb45f72f679"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea0b10613197b26a93c1ca74cb66592938d9e45f38f9c30406531a7b6849169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fcdb7150022f6d84fe4b5668e371368aa3ac94ef3fa777f3db39a7b63351df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6fd2dd0b5fc321f3a86045349814432dbe347d94707c5614707f10a85c58c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end