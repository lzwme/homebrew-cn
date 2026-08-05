class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "fa23d92eb8ec6dcac398891bac3eb9e73b904e9c7c97b34f233871f10fc1a837"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a7dc245f9f974c629fcea6ef5bed724fcaf2666e8bf0bcc615cfdafcd184983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a7dc245f9f974c629fcea6ef5bed724fcaf2666e8bf0bcc615cfdafcd184983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a7dc245f9f974c629fcea6ef5bed724fcaf2666e8bf0bcc615cfdafcd184983"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bd4fc42a8e26bff9fa5f81a87eca8210c6ce8203e502b5863c5e75985049bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a912657e0fc4b7f33471e4255af5843664f628e91c7806e9f9291020ffcf1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9588972a5d4d1d0f077a2b74415186ff12e069f2bd206e38c3dda6957fdc89ce"
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