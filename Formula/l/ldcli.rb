class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "ba83dee7860e5903379a2f91e642caf66c086fb8fda2dacc6069842379358939"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7e8f1ed2c0a4b174c12dd32958902d1ab6661ec7f972ae7becb6e6f6c1add30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "682d67caf76cbf73770540b6ce301966fa8c0ff38b75e6ed755e738a6155f6e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6339c5bb738de6423681a24ae728b4e6767c66faefdfd4b2a31ea9f1cce85d3d"
    sha256 cellar: :any,                 arm64_linux:       "e51fe8827f26946d5f001b9b3cb2115a2e063fc2fca046d992bc1858c57ce7b6"
    sha256 cellar: :any,                 x86_64_linux:      "62e8e402745cd6b245b93f501b5acad1e5a44ec7c1293d19b2bff8205b8a93b2"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end