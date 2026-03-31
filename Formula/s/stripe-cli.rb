class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "8185e9b9ff246f6a4da40a00a4d8e912ad393908eb8a0e2e3d0fd494c40cf918"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "446c04c3752261f887d4cd72cfaba219cbf0e1bf9e19e04190ab7b5d94c6690c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96cbba19ebbd86ed88df34052ad0dfb14034903e9187393429aa567770dcf55b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87fd159c1363dac15dbd1ab580b233c7b4b5a2d1b3ac2d09a4526d0b286f132c"
    sha256 cellar: :any_skip_relocation, sonoma:        "53dba24d5a066254085ab1d6b8f305c57b4048b8c9de7194fbd134a114f967db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "882721cc3412428f3f57e0d0e3b65c745660da7d32aaa9d7b9eef21486a3fa2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea8bce71fcbe21e70499c578b3081aac00f135342dd431ab775dd004b65079e"
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