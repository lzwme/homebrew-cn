class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://ghfast.top/https://github.com/stripe/stripe-cli/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "e130f17d4f9fd6be8eb76a6db8ba6b6ae47294886eb0b382cba9287011be6ab2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "623e866e8093eba8964bd82a695195c318b8a83528cf8d0afc0295bffdd5858e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "623e866e8093eba8964bd82a695195c318b8a83528cf8d0afc0295bffdd5858e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "623e866e8093eba8964bd82a695195c318b8a83528cf8d0afc0295bffdd5858e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e72eb3b73f6812641f4d2c12487f3c6a9a04209579c66176e7d890a117c20b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3a0ca5102dbe973463b631b9dce02fce7fe839bb084e1c52cd29ba5083651c81"
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