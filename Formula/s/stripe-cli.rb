class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "0ebac58f0e0ef1e0e4ba995e36d004cc3d4b2633ce689833597531fe3990768c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ff06a429223591ad62a5590ec0fac6da96866fb1eba82fdf037d7b620001c71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abdf1bf670e5bbd622dc16fbb70b7917cbe77d84a5e6197d11ec0999047c037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad0c7096ec771606c6671a5cd082984eebc262456134d73315b5ed57eaaff9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e315d1a9dfc2f70f274937fd3ee01de2575ea61ad18067e3a113442cf92a2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b608dd4e64c04668aceaeb5b081db795435a819ebf935626f01c67872c263afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95c609bef51c7b93205299bc1cecf882afc76486c9dfe8868c642372f4daac0"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # TODO: see if fish support is added, ref: https://github.com/stripe/stripe-cli/pull/1282
    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell",
                                         shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end