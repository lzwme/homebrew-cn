class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.7.tar.gz"
  sha256 "bbbe51439326da2ff747db22457bc038e375724b69065ff5fcf5df7210412331"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f39f2828e28e77e02644afcc8fbff8a0cdba95652583fa833b8432bccd3b1c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39f2828e28e77e02644afcc8fbff8a0cdba95652583fa833b8432bccd3b1c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39f2828e28e77e02644afcc8fbff8a0cdba95652583fa833b8432bccd3b1c5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7d8a4fae5dc263e83ee2077aa3d29d27366af085bef2894cea9af0cdb076dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f864893ea91c21e360211d3015bd8f0e4ed7fb82ee9c41b6c88b1a3a50676922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ea45d635895803baa04dceeec8f8bf8de9a526969b5980b9b55ee321820726"
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