class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.8.tar.gz"
  sha256 "0be76f37ee06bac6ad5e56ec542be71e828356e37f36f721a3b8b7afedefe78d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "393ed9c9ecf0d993d2fe90c07d191d3feb5223973cb9b8aa780ca406544ed2c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393ed9c9ecf0d993d2fe90c07d191d3feb5223973cb9b8aa780ca406544ed2c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393ed9c9ecf0d993d2fe90c07d191d3feb5223973cb9b8aa780ca406544ed2c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb4995b964178c62b8ab82e1e2aac86b2b8126ef5dff046b8ea2b4c9ad447f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5d5b7ba7ae04c75879d43a05e05ca13420f11737f1d18616ec5c31916262f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b2bf4496de5796add8600a4a56fcc1f6e9c11a43a2c1054c4e1b8434a5cd65"
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