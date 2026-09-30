class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.52.1.tar.gz"
  sha256 "e4b6dfa0589eda71c9c8af9da7f0568280f0d6d81aba8c70577bae4976f421da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e79061c309389231bc41cb0538bfb1964fe46a156b64c954b56c7b485e88506"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e79061c309389231bc41cb0538bfb1964fe46a156b64c954b56c7b485e88506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e79061c309389231bc41cb0538bfb1964fe46a156b64c954b56c7b485e88506"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77c04c042811990ce4e528c4a035b5a89ea433b2808d0bf4d3254668e3f45593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5aea9174afa600055d78252704a04d0edc938c5d5efc7cd0125138a417d20894"
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