class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.23.3.tar.gz"
  sha256 "cd6bad3ccdae6d2b79ca61a9255cef83381683a7cfcdc2de08ad8e821cb71128"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2b70d7817c81ce22adcaad192ed6604b997f9d8ab21446a0f17465ad274092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5418784b7654f5a525d9fb553ccf720eb2d84885275cdd9877eeeeca6ed7070"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0fe9e91fbdb1ac809e20256379a37874565894f738a6c37205aad2ae1491062"
    sha256 cellar: :any_skip_relocation, sonoma:        "5613b56cfd1f00a68d6a9391ebf850c28b85e158fba3330a39aa107191a2a687"
    sha256 cellar: :any_skip_relocation, ventura:       "e278159ea15492ca9c34581145a7cc8e9cedab87b0fc9b7ddcdd05c8e067a79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386da982cc36d2e74cd01360cd2cef3a6822fac30155099f9672932ac25063e2"
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