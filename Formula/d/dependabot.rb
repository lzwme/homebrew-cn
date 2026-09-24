class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "5f20ce039cde14f642dd89b5580419732e46899236f752ff09dd724626837964"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "407a95a694885b532c311e20808901426d0b92aa4d436dc16625c7ed5db69535"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "407a95a694885b532c311e20808901426d0b92aa4d436dc16625c7ed5db69535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "407a95a694885b532c311e20808901426d0b92aa4d436dc16625c7ed5db69535"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd05854392ab12ca4487f7c51ee6b1be6805056669b71b4771ac46b0f8ed83a3"
    sha256 cellar: :any,                 x86_64_linux:      "06dbc3ca9045d5951a1a235c8c872b45ddbcf141d8e7d81e6228c3206a48c455"
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