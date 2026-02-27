class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "3bcd425323743e9f6fca32bfa9b0dd5577d2f64fa5fb27a9a3bcb00fafba29b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e525b4ab72430974a57bc0900e58b836e4e6e0504a0a099cef17accf525c2ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd7b56796b3abd65f18c4b7796b41531fcf69159e407feec982badc354e56e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83774b6820db352f443e26c558536212f3a6433a14557f5f46b9620c9d30dfc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c8253811cf87a351f7529dbe5fa917f88307db1b349aa0d96ced9a17daf586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52759325cb909b0febe3ca34915d3eb6b91eea5a195ee1b51783967b944635b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e319139d0f7e1e870c609a5655f17c85ff9bf520c6ca6ab054167babbe816170"
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