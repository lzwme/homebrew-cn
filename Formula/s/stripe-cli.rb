class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "483954f9aa8c5db6dab50f81016db19a56a632cd287a604cb7b144899249f5b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733978848b7303da7240679a334d8cf2d82c997fa713e08b42a3dc9537b34a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a422d363fbfd016f109d37c5af2281a1a1bccdea65ab960766b2934fdb7907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "139a7294d9e739085574de13b1942e65e7a3ad7f17490dc6a174b62c1a5801a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3ec18e38b7996a74c5bfcbb65595dc61e5e79cacd8d24084d9c498c6f7e0ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc6687d9ae1537a042332760fea06d2cea8bbdf235b2d148d3e6bb6e06ce523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020c4f8f5d1b21475354ecd75c3447d9570c642abc8edb7914250433660d73dd"
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