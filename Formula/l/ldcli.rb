class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "f16b53912eb32d94164032d391a52ea3f847334df25985121d6a53162d4c6a0f"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b89a30c12407f3aab39df301b3d5c26b5f061b17a4f6afc4c9979f82380a3cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab6bccf3f5f72bf18e0fdf4c70b7bc1a7dbedf6cef813f32ee780ff6d595bd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b4009ec6c050051c9b799010a46be5fb5850e0ea4a193ba4b4653634cf50619"
    sha256 cellar: :any_skip_relocation, sonoma:        "1138d89b77eaf43b2b3740257c9134ccc08784efd412918d3992014e562a1a38"
    sha256 cellar: :any,                 arm64_linux:   "fbc2308a7e4fbc3400a729dce7ebd46127869770231ea08915294684f63ff5b4"
    sha256 cellar: :any,                 x86_64_linux:  "0f9e0f0fa8afe43f18cb238ddf192b281345eabbad8a55321fa09ee310c4a2b9"
  end

  depends_on "go" => :build

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