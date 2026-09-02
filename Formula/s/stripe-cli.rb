class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.8.tar.gz"
  sha256 "ba2ab28707ac2952a22ad215d3f06abadae5539e18922a78dc7f08ad4b9680ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04075128d19b9cbe8c292e099f6d126359aebaf7a2c52388899461e4b3cdeb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04075128d19b9cbe8c292e099f6d126359aebaf7a2c52388899461e4b3cdeb30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04075128d19b9cbe8c292e099f6d126359aebaf7a2c52388899461e4b3cdeb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ac00bad20c82e5faababd486679b210cbb49a307796cb259ee9a58e469d154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2f2105ef440d60f47514caadeafce209086f63bba34d90285cb694feea2909"
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