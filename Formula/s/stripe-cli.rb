class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "dda1f3d036645a41eb777b8748309b8e7f23ee135112931d48a97fc029ed901d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dbf2ee6bb97958e00f189b74609c07f5536a85d25a673f372641fa6ca2d925fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dbf2ee6bb97958e00f189b74609c07f5536a85d25a673f372641fa6ca2d925fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbf2ee6bb97958e00f189b74609c07f5536a85d25a673f372641fa6ca2d925fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a24491d02da3504a1a002103db82274aef3dc70707800657c03d7225fc41e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "20c045924af494f2b944dd8c42788cc9cb11f191fc7d39759bb3e376ebb24820"
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