class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.11.tar.gz"
  sha256 "60571665ca0b7021a33a90a0b99adf7d13cbb6f9d28a398a9ac80d646a303f11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb3fdbd154995ed714498c7fc0762affaab63cc7196fd1958c2dcbb014567072"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb3fdbd154995ed714498c7fc0762affaab63cc7196fd1958c2dcbb014567072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb3fdbd154995ed714498c7fc0762affaab63cc7196fd1958c2dcbb014567072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bb3fdbd154995ed714498c7fc0762affaab63cc7196fd1958c2dcbb014567072"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5eb50631960a6471ee61cbeca92e795febaec7993de5f33be679fffccdc14d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5a76f40d37e5573aa9e2fee80a6f4772fcbdd0ba328a440eddb4f844fad312eb"
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