class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.19.5.tar.gz"
  sha256 "3b59dbc36c66b8021c3c35c1a8d05426f3441c4848b7100469f34360061c1347"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e8bf00f7f0f3249679e6c1abe5dd5d4bcc667d30cb09bb2d29abdf8dffeee54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4223af1fffbc7c16c688df3b44fb1609a2ed3719600a91c6a76b2115c376489f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ff0f1f3048b790cfdfd0fd2cebaca9d4ec2a8a58b3a39c61f433b9b8e02f94"
    sha256 cellar: :any_skip_relocation, sonoma:         "a803bd1f9b24291556ca8a317425e278421346e97475d73777cfc6d9e9893f05"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e379992d81fb86c5a21b235d8a83ad8cc8c55dc7ceda8ff2932dfd9e4f532f"
    sha256 cellar: :any_skip_relocation, monterey:       "5686274a43abc586e7dd309e1fd986dd67c8ce67dbc555012846e07470209ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d77c20e95abd20992c207b04d71b424009cabc0a56ca69241d3711c9797b19"
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