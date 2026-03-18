class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.7.tar.gz"
  sha256 "9641e172b3989e4ebc2aa6e91966fb4294be374a542f39991b1978408d123e26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2916fc23818135e2e8ddbd6e38c58069705497561cf008ecba13222ff6511afb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cadec7aaca6a10b05349398a7513c2e8795752cc00cc94c0fd351b1fbedeb8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d1a55f3ee6f04c881c07b5a89b1afacdcc8d99825340d4731efe248f3e5a0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b20923f2172d63c7a8cc070a1c41253f0a264a1452fcaea464958b95d8ecc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a8d27b61f42248d90074156aa31b10bc15516326c3ea2294549f17c1bbec01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da84c751828fd76a3d4f14df08340be8e1ecf2570b96d8934e9e79ad67a106d7"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end