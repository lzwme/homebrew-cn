class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "dfe9d76d8364418878916b977998425570ec49736c78b3a55f0a1ef16eee013d"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aa7c30b53a86357a5499d55c33498e3b0ea5931f87e8a3c9e31e45454571ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa7c30b53a86357a5499d55c33498e3b0ea5931f87e8a3c9e31e45454571ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa7c30b53a86357a5499d55c33498e3b0ea5931f87e8a3c9e31e45454571ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bfd633a81eddf8c8b9ecc42104932926830b26a91a895061d66516b1ce97379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55362b23e5cb83a2536f33bfe880bcc560f2ed4f2f7f819a8e0b8c5cfaade3d"
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