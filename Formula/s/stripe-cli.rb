class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "69ef37df57f0c1731ccb275c157fef100b5ca94efba8650161ce3dfc1f4b6c54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d4b3b5905e0a3a450f59e070053aaddf509e1fae4aa34261223e0a51780b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b20784ff428c484bf7c4664b5b1b65c0304c9cf31ca8acc37c2095ee4fdb97c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c1dcefe23e1b609e0012da813440d8b4acd00d9983c42e4e5de20ed96788026"
    sha256 cellar: :any_skip_relocation, sonoma:        "d344ad583b543289a156310d351f47a407310b8437cbc927a871ff2f2a1750a9"
    sha256 cellar: :any_skip_relocation, ventura:       "5234bd88601d251c661ef2f24ca8ad6f4fc5543e8d9466a02ab331cdf066575b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43cf2bee8050f615fff2b91ec35931c74832597466e0f15588b80d638dd960c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7def9df29a37bb75ee0382f1bd8997003a14986a02a5a45227f523cf757c2d78"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end