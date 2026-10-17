class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "9e253970e4b87647c0478a2fda7b6866be559c3155be52bafe846c5a8136c6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69e82f12216bdea0cf8f51b1bc5023afbfb6522a6ff5a286e4c2fb0df0b58633"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69e82f12216bdea0cf8f51b1bc5023afbfb6522a6ff5a286e4c2fb0df0b58633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69e82f12216bdea0cf8f51b1bc5023afbfb6522a6ff5a286e4c2fb0df0b58633"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04c694a87579ec4909f34ed01002d06affdc3f336539989f5417a15ff077f03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a56752778a21f5a74cbdbf83d7bfba530fd65ed39a8dce8b218128c24a2615e9"
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