class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "341ee1e2d460f80e7323ef3cd8dce2abb08ae27844c5ed72d90128b9f40eb48d"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72c90aa26cc40295df091bd52a7365f35684391a220e8e37d9071a9604971549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f826e92aef9ca4b77dfb1ae07c01623d0084a890934f082972580e30e38cb582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec75e05ff6ee4af07ed1503549df99e8b97e0225c80a704cf6eb4a346aea2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cca02109b4223c18bd424765b14a2ed1aaca34108fe6c414bbd25795e6b3f3f"
    sha256 cellar: :any,                 arm64_linux:   "7be6bcd016317cad68f29e3c98a9657bd8c3396b58507994803f754ff31281a9"
    sha256 cellar: :any,                 x86_64_linux:  "3351e6f8c1c2c8047ff258857fb941e72c6e015c4bab8ac1378146c3fa7cf60e"
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