class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.10.tar.gz"
  sha256 "457d7bc76dec2cce2d284ecdead7f10c8e9397316b3c0840b089855988a65e7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ec5002765bcb5c520313315fb868c607b987a752a4cc02c65d64c402a47186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5413f0a03d3d45f59316df357abfb2a2d5eeec809f52dc3964dc7f3b6c600abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1491296746c6539c4195a51a635222ec2d8d9936065413e31eaa687a305c1bc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c15bb58a3803dac551d9e4c2d67bbcb63be7ec5b312812df150e3a00e6389e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d10f40053cc2e89c10562d237db20b800615c656714dc51aa55ad7081de5b8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b83766c34c247dd746268409e42685c3b0b07c99f93b6f861a4cf5089b1adb"
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