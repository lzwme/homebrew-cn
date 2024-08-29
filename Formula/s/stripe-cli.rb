class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.3.tar.gz"
  sha256 "e532876adb1d330e78a163ea5d3fe3de2c601e5502b027d6c0bcf724a8364235"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a5f8ef0a2c7619feb12352a49ddddab109a4b77f2d4368537901e22cd8ed909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8dfe7dfbf4ce61e3dcd59d7548c1a06a09cf0cf6131c708782c56bdf73c1620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61c5168890fc252dba80a6971833d3d4b5c79d944c235907095057ad6031449"
    sha256 cellar: :any_skip_relocation, sonoma:         "355e3b8f569370935336dd8a9df5ba743761041ca3034130ff15218e9e64a2ed"
    sha256 cellar: :any_skip_relocation, ventura:        "7fdf8a9aba1cebd4569fd850adb3373e87d0b67e4eafdcf76de63f8f184d5468"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0619eb66d7cfe2adcbf9e958c57f56c23331a27ac1124194d6aa49125ccea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd59c72f590b9966446ae505df36745633d6496ae8b713cbc6d6cafd79c87df"
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