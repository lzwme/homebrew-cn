class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.2.tar.gz"
  sha256 "c21ab3ffbb6ad8229c98d1538fdc953fbf34e1f25e62e3a561e3461467ab3a20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d7b5acdfc87c9d7e81fd88b4ba707e43cc44aa1477c5789655440e4d04b7fae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d7b5acdfc87c9d7e81fd88b4ba707e43cc44aa1477c5789655440e4d04b7fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d7b5acdfc87c9d7e81fd88b4ba707e43cc44aa1477c5789655440e4d04b7fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64225dc5bce9eb4cf14816aff3a7a159ee21a778115f20a5043510944a1e5c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdb04a0aa7a3cbb9fd9e43b62d77b0fc9a4ac5bad4509b3f8a08ec0d85e27536"
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