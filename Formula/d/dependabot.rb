class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "c80968da8401d8eabfe54b1269216da19dbf0d11e274166097bfb4a812480ba1"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c288d87a308851e9982aa1f42b0057faeb8cf8e00d6203d50f7dc0343e2d4bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c288d87a308851e9982aa1f42b0057faeb8cf8e00d6203d50f7dc0343e2d4bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c288d87a308851e9982aa1f42b0057faeb8cf8e00d6203d50f7dc0343e2d4bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "01aae61fad6d1e3c52e706447f35fcfeea2cfa10ff763b82f22c01512c9e98e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50ca889e216f2541fd5c178e8936bd8517b7343cc5144e7e11b4a9a279f1ef85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7467cbe46ae99fdaba77e0b612c6e9cc4e339b7d9250e265f06cce70916c12a3"
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