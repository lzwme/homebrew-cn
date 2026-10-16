class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "cd387c2d4dbf7810fbef4838ec6645eada9a86ef5725215ba9e657c7d0fa685c"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3173374035296f3b72f47fe83d1342d4ce7c0790b05a574506b96ca6c90272e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3173374035296f3b72f47fe83d1342d4ce7c0790b05a574506b96ca6c90272e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3173374035296f3b72f47fe83d1342d4ce7c0790b05a574506b96ca6c90272e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1e90ce406870a123f41e7447bfa5cc5d2d94b177e5bda577133e11149b8628f"
    sha256 cellar: :any,                 x86_64_linux:      "eb887ad0ed9592ecef9f8c69376a3309e092e8d9d816f809e26dbf385579d237"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}]
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