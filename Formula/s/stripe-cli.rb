class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.5.tar.gz"
  sha256 "75d24e83acf8958936bc1481832c7fc22c01d33996a18749f70352f7607a9877"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b551075ad29fe996972ed197f951b58e566cde19c3cc87ba5f353ef54ec57320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040b24ac59ebe16089a904006647712c5268cf4c788f45c43fb4546b136e120f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a43cdba28d4050b961855932147d9c11afa5ae603464e8ffe23a4b6deee9ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "655333368595993e980515a26701cfc4816bf6165abe69e21854bcf9e5f18827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c373d514a8050393060f3df1cc26213b961e8eeadee544296131f891ecb9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0345b5b7b5601ca7041bff795553731fbb1e39a24d2055935bb231ddf474556d"
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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end