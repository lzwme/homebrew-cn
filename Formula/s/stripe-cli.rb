class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "1d17b7252b3f7b70fb5339325022f64417a9c2c8f4ee4979752464bc36f854b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b93a15ca710aeda973754118338e85cdd2924424395f3aa1fa05ede53883d62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d907d9959b541347087bb15e3d07b5fe692296e1569a13c90d8b413e985e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bcc7f4dd0634d14502215043d66b3011fee718fdfd6c13aaa38a7eaaa0f159d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecbb0ad73f9bdeac6e521622fce6fc7205cd9bcba3220c5f91bad1712dac7e63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bc8afb807aae4615949f9fec0f81d9b83c7dd7da6b149eb054cfa75f6c58986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ad2f225ac09f57e7cdcb6ece64d6ee86e7d0123a5af5de4dda24702fced293"
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