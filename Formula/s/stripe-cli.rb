class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.14.tar.gz"
  sha256 "85a7f5098dff21b538101a9d0377b54ebca95e469ffff2bfee6b4c091d8b3d10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32041d749f8ecd84f9f2b20e28ac8d70df93ec2d3fe10ddb33ee81c4a6279fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "429cf8c2facb8986af3a7eb88d87db0b5d9b7f375e59039a5fb290679e9c0712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17dbf4c467a674906e380125174fc3f9b9ca71aa8ceef94d01fee6a1b1bf50a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3c1699e4861b00c897b3b6be50252d681cdfbec6fe74dcca0b1cf42905a7ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43c9f5652f17c093d7f380a5856853c161128c16709c21235cd86ab3dd7683c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c3672b2425e7e4853552a5d9d05aa765a45ee1588c8f5dbb8531f5a99871a1"
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