class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.3.tar.gz"
  sha256 "32befcf6f25ef6b83d47138f5ed307201fae145bfe3bae306d27acd484e980a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6653e9f97e9eab35e40419c5783ce3a58b2947e5f62f4d7fb42299d2236abf08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc01e0a775ed13bae79c84d9b358c4ba357456cfb24d7598de797924a36e5432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36283d023d48df215ca66daea45b4e6a50911bc44f6f3718fbaa04a31e839427"
    sha256 cellar: :any_skip_relocation, sonoma:        "314aff1380ad155a4123509a42062e3edae815573eca3508a551900e255ab964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07389b2974e99f74e9fe5c0b9e7d9c98a2b88ebaf1594b55a2709e7593455a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f62f23585d9211a3c7c094b2c2e564acc00d6e9ea07376286858adfd5b2a9d9"
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