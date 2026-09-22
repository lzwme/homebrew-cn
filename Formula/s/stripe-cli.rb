class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "0b6d266cf5c707c09b36d832b909b176bec6dde3cd3ff6996d11e7e277260bb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78e80061191438188d19152948c1905b0a3910c82a58793a630b21b529511d8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78e80061191438188d19152948c1905b0a3910c82a58793a630b21b529511d8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78e80061191438188d19152948c1905b0a3910c82a58793a630b21b529511d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f1f850fdef4786175f74f06757e8767c6e079fd1f3d6d526ee18fef7e98bd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4feb4d81ff54a59ea21b6e917dbefeef64af13e15916d6bd55433e4b3e3966c8"
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