class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "9940cd0d513d623b5708b070cabfcc1caf5afdb173b918ebafcf50a9f9069ad1"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60b3034ad67a99949d29a89d534de578c6e3d8a4c751b319aa97f3392627695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d60b3034ad67a99949d29a89d534de578c6e3d8a4c751b319aa97f3392627695"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d60b3034ad67a99949d29a89d534de578c6e3d8a4c751b319aa97f3392627695"
    sha256 cellar: :any_skip_relocation, sonoma:        "59592801e909fcb483548b363386192648581d8f170c1fe84becb08e99ed6af6"
    sha256 cellar: :any_skip_relocation, ventura:       "59592801e909fcb483548b363386192648581d8f170c1fe84becb08e99ed6af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b49c52b06d6d228b3b901928d53a8f6deeb8eb8715ae1f3a79c5996e3184343"
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