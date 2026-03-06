class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.83.1.tar.gz"
  sha256 "2de1c2e3a6ba0d57dc311512276eb0d173a0ca6e4fc579370ab39dbdd0461ac7"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5ebd49094d201700c8c5fa0736ca6aaad276ba263566daead833911a318538e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ebd49094d201700c8c5fa0736ca6aaad276ba263566daead833911a318538e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ebd49094d201700c8c5fa0736ca6aaad276ba263566daead833911a318538e"
    sha256 cellar: :any_skip_relocation, sonoma:        "065606b069fb405baad202810d2b10bc97281a98fc212f66c223a92e7d1e8697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a215690b6bec2f3ef832185cb02c88a7ee9a8a675432a783e687b015cf172c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a8215b7c9b1f0d6d0cea510a3d9720f999da13d957f032d861247b8fb2286e"
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