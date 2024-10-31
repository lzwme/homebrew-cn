class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.11.tar.gz"
  sha256 "ed8c2ecc717e31fe40ea7f6b906625ffea0433a90b4e6974a289a2becefa8abc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b69c634c65c1c9e0d87693568b7d463c5a6da627fcf251daad05c1fef5097d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab49aba021018f04f1e6f9e87e6698af019f8eb2e02d1ca8cf8b44113a7ea13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74ec4ad6c409e61a4b0ecbc8e6b65dbfb865de8854a0aec6dee88b9c16b5fb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceceace4daa7595ec6b84d21ab0560e1de18f2d79eeff8d0c2c73527a6002496"
    sha256 cellar: :any_skip_relocation, ventura:       "a876cc1996d86c1a4b1a29f3e61c3c172daee7f8d90605bb7e7a5879ae2fe435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d81f2360851e2c6ba8ac70f271c088fa108d8fa39f1a59d3b2c9f21f0921c1"
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