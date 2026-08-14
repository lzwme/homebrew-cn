class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "b7ab4cb77e65dab3bdbf488e793faeab2dae03ed38ecaea287809d3305345201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c77f3006a2335d49434dc6654659aae09e4129f8bc5758f8ad709a90cec0ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c77f3006a2335d49434dc6654659aae09e4129f8bc5758f8ad709a90cec0ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c77f3006a2335d49434dc6654659aae09e4129f8bc5758f8ad709a90cec0ae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3406998a58f0859ca174348f5ead0c6638e4ecda5c18f7134cfb42d3d341035e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fccf724a0c7dad4899898793838d7eb44d0bee3465aa8d87303405ac188161f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f2e2b7d7eb37db13810a6069b9acccea47dc8c794da18222a29a230c212521"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
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