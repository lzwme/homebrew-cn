class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "61b98187ccd77329da22d8345f70abc54d8d719f99a1dc9d9a133324ba2d6221"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1878b2b402d93601a4a49a0cde61aa8694e2b0f520e7b5abb2cd1f2f5609c8c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dfcae935cecf6ccc748d7c772d08ba66b72a24158b8ee88c3fff39f364f3dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe65d1d661f10b2ee86df40f2f9f1b76f437755ff85b83bd353147d2555f2f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "04fd80bad4aeea30ae91b266b87b7e4d1025ae3345fc75ad18e539c00482afc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b418482078b2e1df9d8cfdcb5a3dba08efbb2c99313c695687cd0f6a812665dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c16f2b29111745f449df507d3bfd1986b744a77e88d66ec75de0cff5bc1ffb0"
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