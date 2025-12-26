class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "c80968da8401d8eabfe54b1269216da19dbf0d11e274166097bfb4a812480ba1"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52ac1f299e6acb40b1cd89db253a60aa7c940c3752399609e3fdc35b32bb3f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ac1f299e6acb40b1cd89db253a60aa7c940c3752399609e3fdc35b32bb3f93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ac1f299e6acb40b1cd89db253a60aa7c940c3752399609e3fdc35b32bb3f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "7543513762d685ee7eaaca304cd5d35cd1423eab85a76baac006ffd24a0b1d97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ead60c26fddb71455311f05244f005039e04aa8d5641ac64fe549e371fd467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711d2890cfc3dcad998bc83e6f1eee9d3fb2cedba8b2e7d86ea33c35c22c7778"
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