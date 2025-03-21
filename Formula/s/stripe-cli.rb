class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:docs.stripe.comstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.25.1.tar.gz"
  sha256 "42616b66c1bdd1c76920b68154e15af0e5e42713fd0845865b9dea239cb47cb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b1cbb9bbc3f3747d09d7615f6af53e62bff2c586b0c98625ce10013ab9fb62e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40535ad02376897327278add8f18cb782d37d8623059eb95781ac2e39626b7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "483ff06ef4c596df5a8bff1a6fa1ec4b67467ea4b40584e4d1c1a43511c82e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af4f2428aa971185bb6271f4b827541a1c2cf7305a63737bcb2b0811b9b572a"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4c0a34dda03e0ee296a10874ff102d1961905e0ba6ca9c174f76481faf8fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b56800c891559e04c6de74df0dd298d7a7628a5e163dc08bb174cafcba8408b"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https:github.comstripestripe-clipull1282
  patch do
    url "https:github.comstripestripe-clicommitde62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.comstripestripe-clipkgversion.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin"stripe"), "cmdstripemain.go"

    generate_completions_from_executable(bin"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}stripe && complete -p stripe'")
  end
end