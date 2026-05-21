class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "00c217fed44d41dd8546f4292057178a510ffb32abdfad1a1947bf64e473a4d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e0024794e750587388fb270f068c292b55b93541ac23e806abfaa5b1a7a091d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26906e9dc1d7aad435bb48d081014a2c4a5790bc73d4d1ee305ab15c54583779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c921447da06b92f13ef0fe1991072e6ddc83937e2279384269c43d2d125492"
    sha256 cellar: :any_skip_relocation, sonoma:        "9453eeba400f3408f2b8bd0199949cfcc1062a0b243bfbc470af64b0cc64f2d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea139104813cae534148a37c58366bb722e6fcd3134cef677143e58ce0273147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179950e5d4772cdbc02a90986852b5f0f8ed962c1e3c0d330f414aca756f72a8"
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