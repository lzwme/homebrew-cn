class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.13.tar.gz"
  sha256 "5920bd906332c381fa6e5449f5a8e97fe8b0464fffd3b31c06b20b625890faa2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e952c0a2daa3cae9046cbdc584c874e5c3567600ec3f86907a4bb891e7308f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58c1bbc6c7885f5538b92871c23e7ae4334ce86a76d1a40ffc61cfb1c0b78c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7c465b23e362b251e6084b2c1121583471521456fbc936eeb4fbe22089fc71"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5643435a5f3c38aee9afbda6f834ec3e3dea09c0ca9124ff4b2c749a85a3c46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fddcd54481c5ffbbcd03f692485101d7d60ff99bb162690aa4d3c03681c5c8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae23757dd42c223ca98079ede0527d0e449e1e0bc136e87b745546b7169af1c"
  end

  depends_on "go" => :build

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end