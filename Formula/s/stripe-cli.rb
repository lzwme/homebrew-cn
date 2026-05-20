class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "c3c05b44812eed2de8e7845d2f0a1938b155e16d3ef99eb864ad334222a7ba7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2b59991367a369d27fd113a0910dbc598e09de3c3a4ff870c8858aebee8f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc41085f18590d02f1cbfbb2e02fa1fd979922ad6b8e128e8ec1408ff9df956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1205edc28ac9e8f9fc559214abbd36aed0b2efd83cae4a820ac80223ba43e8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6178e3b6beadd4d2145a7a63e23d330a8fdc5c59a5e506c241fd90561d109d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "689f7c53d1dad5f77906d23a4c4e29650b0dbafbff158f26f655d5c8e3236def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76f4e7e499f6fc7985cff00625041478173540bbdf69f6aa9f579452379851d"
  end

  depends_on "go" => :build

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end