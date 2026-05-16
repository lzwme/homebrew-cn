class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "6a50c46a184db0322c4a9e3797c7a365f3d09e719fa8cb49d0291e2516c8a18b"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "663a677cf7506b99c8d5d6851cb76d2cfb47c5451b7ad7acee6c2e3c13b704cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663a677cf7506b99c8d5d6851cb76d2cfb47c5451b7ad7acee6c2e3c13b704cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663a677cf7506b99c8d5d6851cb76d2cfb47c5451b7ad7acee6c2e3c13b704cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb635e7a53f678436c9f7cd7f9567122363727ec35556bf0640fa6bbd170e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d097149060286fa36164af968353cf3871318a06ec63c5e18a9046d053e2e6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca46a06f8a7ddc09da431086282f482542ac2a56d7e34b4fef1cf2dfc3c20a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end