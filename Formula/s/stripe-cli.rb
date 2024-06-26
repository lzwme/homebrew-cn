class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.0.tar.gz"
  sha256 "5c5520cdd621c4dcff9b7d4bd0bf0b8ee285d773991aaf9d60a7398ddd939ae1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f3e5637e90c4bebd9a27c9c566c80c80c64168ae7ad8db012fbe307eb4bcf3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85b4e9b56a48295bf2e81bf34e629da5fa31195c832b36c36960eb4336bc70a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bb64a232b3339fbfdc8b017f7a74f7c16b1ea18e93d8af89260bf5db3ed82b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f80c6d45be981e211a217ef96048eb9c297af056ca723852db9ed12f05c9a15f"
    sha256 cellar: :any_skip_relocation, ventura:        "bf06e760c64be40c23a591a87484a88fa9dfc2ee81d6f60c7d8129e9fc36a07a"
    sha256 cellar: :any_skip_relocation, monterey:       "1921eef375583d795a0203f0af09f507e0d0d93527eb17e0278f3ab0ebf7a987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44563217ad0f7e93e52111da7fc8ccb02593e2348f514bae07a95099c74d3efe"
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