class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "9d77ca8ec40dc04107b55db75f4c8cf286eac496da750d4ad95325f027df6852"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "855afc03e7796b8aa9902fc725814eb379fb823ce2367cd3a6d6fb313542df39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc852fa4cf7f4e042455790407b14206feb05c64252aecc1b549f9b3800f837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c80ac913033a0a300afb134a0299dfa64a7e44e00dc531d56bc3011c9bfeb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a2399e943127c97ddde9f0eb12f8adae4c9e02101fdd7783ac70659203e647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9164d98297080a297466631117259d7a21f80d9806891f582eeb349353078066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d14c96be66ce7759a6bd37f02383936b536d6d469f95fe587cb26059f22186"
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