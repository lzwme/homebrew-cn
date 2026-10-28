class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.3.tar.gz"
  sha256 "a098ac295fab3f1875a6787bad4b0b02f0249ff17e85d393ca8d826232d08d63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bde4af0a5a418011a239e76afea880159b27808b1b43dbcddd733cc3545a95f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bde4af0a5a418011a239e76afea880159b27808b1b43dbcddd733cc3545a95f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bde4af0a5a418011a239e76afea880159b27808b1b43dbcddd733cc3545a95f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2aba8a492dbe6d95f86f210327085d404550950ce9199d844d0cd1bf4c4351e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "295a9192a3f66d35f47b657b374b2a27f78d94fc4ffcb68554a977f3af9f7dab"
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