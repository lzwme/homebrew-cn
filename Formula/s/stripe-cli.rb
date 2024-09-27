class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.7.tar.gz"
  sha256 "d7e1acaf1720a2e039695f56d800e1d31f74ef165159c1745222c02a64294153"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6ca0e53d7114e8fb6123d87076ce2dca8ab78bd28eae4fe3359ebbcf80cc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce2411943729f24a79a6f3b65c3127902276b7bdac7bd13b59398e3e73f7374"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efb3b6686c2af811142f766e57f356a62efe4eb5dde1af6a7c2e4e27eb1791a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a7a4806c392bce6a9472a5cbbc9a27cea7ab9e354cbac6a7de70aa30d87e6ed"
    sha256 cellar: :any_skip_relocation, ventura:       "e5422929a714700f529b5b0941b60c5d8f493117dbfe554419f22bec01303579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c863360236a4630dc4607c5f150c587bf8104f966eaf622305f2ba0f211cce70"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.comstripestripe-clipkgversion.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin"stripe"), "cmdstripemain.go"

    # Doesn't work with `generate_completions_from_executable`
    # Taken from `.goreleaser` directory
    system bin"stripe", "completion", "--shell", "bash"
    system bin"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh" => "_stripe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
  end
end