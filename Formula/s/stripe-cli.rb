class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.11.tar.gz"
  sha256 "001659211dee07d685e0faa8218c9370755ff82858042016ee55dc660394514d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ea28f1b7c81e65f3e33eb7253d169fa0643bf80786101c3dfda934ed3131ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ee81e5c1460fd4848e50ed6044dc82624e23bd60890f9e39968018d334424a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a09dce5a24545ca1d8d136972666c8416c5fb6b061a4a11d620ccfb37251d01"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f49c368410f535a4213f4068a04bf2960216ba418f2def221a35b427a146e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a31a865b6b2fdaa2ac66c48aa78e71ddf93a7a27ccf19ecb9ce4ec5660d837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e546f1c760e1c627ec586b4b1d4e25195925610a3af3910b0acdb1b5fec238"
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