class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "4e79b0220520f3b6e7b133e0269c5f3529806511fd869b35bcb9f8a77df778b3"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "791467ddfac742061b290cfc7b4bfde66e03610c2c9944912d0a2fab7c46303e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "412a07baa97fddf346f6481def8c6cb7c3b55868d8ef4956874f85aea28dd9bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9c7e85c2557b354ed096e97e0b2ec2b27f847295aabae77ba92e0becc2481f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c885ce3f02235ffd226200e8ed7b4f933120419d1a3f8e002078f2e41c3711d7"
    sha256 cellar: :any,                 arm64_linux:   "ffb61fb1ddc526055c3a3d36c9fc25f221b0352456d8126a568529ea99c553f1"
    sha256 cellar: :any,                 x86_64_linux:  "61c367439681e17e14f889ee934abf60bbaae90657c5bd1d863d9377a243c5c8"
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