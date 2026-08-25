class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.5.tar.gz"
  sha256 "ce2ff2fc903fc6ca0fef7c7e7f0d29f80c66ad57d1a2077110166c7131c7fd02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "892dc20ceed3b91c4c3b7dbd2111cf98c893516ed3978514643c492c9e8b0c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "892dc20ceed3b91c4c3b7dbd2111cf98c893516ed3978514643c492c9e8b0c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "892dc20ceed3b91c4c3b7dbd2111cf98c893516ed3978514643c492c9e8b0c70"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e900dc711a9e2841c5cd93bb97bbdcca537a82a6ca2cf54077f5b6f1e4c25a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6da729d1aea906d67adf38c38acfb3cc7e075efe965ef59da5b0ec0e9a0a8fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69f7c7f20e06601d440bbeaf7671fe2dcff2f651b8dd67bb97dc989b18d9262"
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