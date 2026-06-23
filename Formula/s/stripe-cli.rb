class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.15.tar.gz"
  sha256 "26fb3292114423cdd9ac2d133c161d7317af312e70f37bfd830f72882dc43daa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09c60df30d8c2e3069667189c5f2509c7d8f9d17de2363f6dc41b1797f7dd708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "583e16ead37192fcc94e02806f2c155bcdb9ee5ca6deef7adef5ea8917fa30ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c190422f27db655ab92b1ff581099ecde5b20bebd36d7b2de9d8aeaf2c0ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "58200dcd9496f16a3bb46575ee693fe43619a66c76f24a34da2fc17acb4ed87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5541f71ae7cb74245bd7b0082dd31500986d6d00f1baf0128c3e11d4fa67d90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1133713e809af5fe64867b254a6fd36ad56ba1481cae1132fa076db5e9c2664d"
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