class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.6.tar.gz"
  sha256 "00abc9f2adc17f1425eb550e393d34892f0d20fd2845e0457f75faac641ffe44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c65634270cac1441d8ddadee48819c26b93e42273fbd58e3670347705af4f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1d8fd461350559a0935171950ee1aac7a204fd691e799aa97f30d60fe3de44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "900823aa0ea085a28ee9694effdb38b829e7ab24a72a3ba567fd5c0da467b553"
    sha256 cellar: :any_skip_relocation, sonoma:        "825a22098afb0a47f272da4549ee30a98afc06f1a12cfd5f38b48b8f541b11cd"
    sha256 cellar: :any_skip_relocation, ventura:       "6da8b4bac898c94ab957820fd884f52112e3331fa21fe6cc138d030d11fa49b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b1a06793861ec6fded451d3979895da985278e75870b426f9fa8e2c0d3c4cc"
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