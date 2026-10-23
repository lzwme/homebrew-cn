class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "ce12c100dc8a95f17f5e759cdd0b0fdcb281308fda6d8a3aaf698c17678bc780"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9bac28094d1184e3fff06550355e2668ee5b4decf06c1a2689b7709a3c0a101"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9bac28094d1184e3fff06550355e2668ee5b4decf06c1a2689b7709a3c0a101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9bac28094d1184e3fff06550355e2668ee5b4decf06c1a2689b7709a3c0a101"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea4dcbb78eab468df99b64eba56b317e40aed776afd4f99f4edfae98b0697438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dabb214b82ead7bb1db301b0a9da72d22ffabffdbed1794f47ec643737da2657"
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