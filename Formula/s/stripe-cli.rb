class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "f42d5b38552a065b78da1d3088468838e8fc009a80f6cf56975aca687d6b6759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36098e81a73e9f0f4c3f43baed949849ba814e705bae26625149afd2267cc38a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36098e81a73e9f0f4c3f43baed949849ba814e705bae26625149afd2267cc38a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36098e81a73e9f0f4c3f43baed949849ba814e705bae26625149afd2267cc38a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce6a9eff04bd69fe77cfc2f7945f007d4f399a4ec33623286bd0ee25099188d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d20d6330d4e70f059d005d3b8bfe395d6f407f1b6c71a6aba5d7c80a4323a49c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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