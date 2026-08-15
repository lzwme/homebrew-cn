class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "c2c6c87a3b278f00bbfffb595fc0529efd36b0617c9c2045637687020919e5f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5576a0c5e66e1e36c6bf069a0cf7292a9c2f2ae64f822667a6ee6197166872ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5576a0c5e66e1e36c6bf069a0cf7292a9c2f2ae64f822667a6ee6197166872ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5576a0c5e66e1e36c6bf069a0cf7292a9c2f2ae64f822667a6ee6197166872ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a29222d4dbd884152cf6535f79e50638762208aa3d4a2a970691268394fd76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cb7d799b216a19a4f2b16d9b98190a0905422a58546397a85f887d5708b8027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7eccc1e1fb12eba8a5fa4ca8c804f972dc4a526a245c83dab6a650b67783ef"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end