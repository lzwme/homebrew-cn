class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "84d9051e77e4bfe71265371ca4f6aebaca3f352de1230cd5be6c78369b0e676d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38e71ed45d13500701cfa460bb44f63888ffba708abad75a97d580b4ef73aa0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db3865f21d76a8b06bb78a78bf6bcfad1b1bf57a7523093d19612fef6237cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c00409a6ba64506af2e1e294801bf1ee58fc5aa11ab381e7b6d1f765d39c5da"
    sha256 cellar: :any_skip_relocation, sonoma:        "061194da4210a914a0076c6300fd38ae66eb15a53879160cacb6d56937b32bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e7e3dd1e597fbf1a177be4739d2d12b905776a2381ac1a7d3fc1223c9fbaa8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fcdec15e25e5dc976750f476334785692b0818c699724b17a52e88b11702ea8"
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