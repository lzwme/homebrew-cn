class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.53.1.tar.gz"
  sha256 "133f88a7393313ef4367413fd95610fe78d509bb7ea61f715766eeff1cd31a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2726725882a0efc178762a74619fa84500ee4e390996c2b20d9a13b6e61b0107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2726725882a0efc178762a74619fa84500ee4e390996c2b20d9a13b6e61b0107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2726725882a0efc178762a74619fa84500ee4e390996c2b20d9a13b6e61b0107"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1703a6996ec97a84f8be01bcd7ecc8a664785136f65c99aad8d9c25242afbe92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "449e9d1173edb4b934724389a2d67f3d72d267e601d1cebe46961729d1fd7659"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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