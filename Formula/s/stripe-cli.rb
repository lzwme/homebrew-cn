class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.44.1.tar.gz"
  sha256 "8071c03fa093dc9f4456970cf45c30eb325a48d0e820307cf4308d2541eeff5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed86f3cc89d9f332a3db1d647147a98eaca7ca11bc52cebebed7e0b6d872045c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed86f3cc89d9f332a3db1d647147a98eaca7ca11bc52cebebed7e0b6d872045c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed86f3cc89d9f332a3db1d647147a98eaca7ca11bc52cebebed7e0b6d872045c"
    sha256 cellar: :any_skip_relocation, sonoma:        "df279536cce354fa5c810287e91e8294083ddd49012e841cf3231e0a5964fbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa23eed6053a620f3a5ae797e65a74f5f16bcb4407e4741530f5edd12671bd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3a7c09341996532b1031ca56e1906c7e429b5a7ac3c4cd1ad26b05c6e580c3"
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