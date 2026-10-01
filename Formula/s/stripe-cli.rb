class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.52.2.tar.gz"
  sha256 "9e313f48d5a44b4f01063561eb2bedf36814e961040be54bb483784ec51dd5b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5d78a9f8abde48daabc263c7645420c25fe9445c1bad0f5ad0ba794f38c8926"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5d78a9f8abde48daabc263c7645420c25fe9445c1bad0f5ad0ba794f38c8926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5d78a9f8abde48daabc263c7645420c25fe9445c1bad0f5ad0ba794f38c8926"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "36260043438b2fcb1995738f5d3c30810b0b9cbbd7445bb2b6e2e82c7282c9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fe63dd7c1a4ecf39ff45caa82731a84bc6b590f7d0bb6aee2e7a8edb6d2e4ddc"
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