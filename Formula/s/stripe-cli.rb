class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.10.tar.gz"
  sha256 "1dc53563d513575d614a038b38dbdbc04a057ccdde4af6ae281269e9c45c7581"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "611b886e0ab597220cdd748ad5a656507942f2824891cc3d7a0ca76cacb80f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611b886e0ab597220cdd748ad5a656507942f2824891cc3d7a0ca76cacb80f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "611b886e0ab597220cdd748ad5a656507942f2824891cc3d7a0ca76cacb80f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965e7717b30da6baf21f5cbd6abe13413ae42ece9ac579d82a94547335203b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855828fb22535205d0a32b31100ee534c32762e210d8cd5071e953978fa4e9b7"
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