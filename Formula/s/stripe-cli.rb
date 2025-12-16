class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "9847e78ab3f89b605f90b2d5130ac115d850493a04af3aaef744c1b29d573d33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fcd16263523b3bfdad7fc1cb9445e2a30d43199f2e4a296f30802ddf050402d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579d894654507bd75c1b44e860bf12d1e382d6bb2c4b04285e56fb3a01c161bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd484f1badeea8b1fb23036ccd677e7d46310eb0fd47a2a3b77ba2cea989cbce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22f72d0785abd6dc27223c0290f4cd3f335b5b6a61eff7cbba9eaa6707813b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d195acac383626329ac4d558516b920f1a3e8b56a52dfe2ffbe8614727be01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e2a8a0a5fff25b25e65a114b66e8d68bceff814dfffff5ae4b7f05638819c5"
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