class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.6.tar.gz"
  sha256 "19044f33896bd21925f5ac828da8ee41512ab629b177476a716f49bfdba65a33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ded16c7c3dbea722b398d824ef64029c1ebd3b7510c34b92d30fede67ef9c61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ded16c7c3dbea722b398d824ef64029c1ebd3b7510c34b92d30fede67ef9c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ded16c7c3dbea722b398d824ef64029c1ebd3b7510c34b92d30fede67ef9c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "4372507b3e5d766f35553b3e78eaa37afe75cf0caf5f493b6978b8f70c840ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6ccaf3b93fc8a934174c6796b0b026e5564bc8a4c4a69cc18a587f894e5c3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6d7c14f5b2d1fa67c3c7d7a9651b894ec2deab1062c7c71d8b7aa1311f5d52"
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