class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.4.tar.gz"
  sha256 "b6a68f63a4c6f474c077260a8a1fcec7865d24f746ca8c16fe46b64e03cb7450"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681682590cfeb1eab9fadfeaef14964e20227e98dc550959babe04e65b6fc0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925d466269379f7169c2df4b08b8070cdcc9beaaab809fbeb89e4f1c93432389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f46c2bbe3015aad4e53c3f1e9d29bc9a83344a09942973aeb8ab1b866319c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "688297000450c4b0d1e9bdce44c95f4efcb4fcddd85597106f3c2ad32482f1f2"
    sha256 cellar: :any_skip_relocation, ventura:        "185c5475e20684cb81573196851fb16331c9c1336ab15b92f7d4be17ef5a70be"
    sha256 cellar: :any_skip_relocation, monterey:       "61778cdf4c49c8d2d82d34bceac006ab492693e58e3b01ab69d0885e86d7873b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e22597daadd21dcbccf34ec1158ff0bf5dd88258ce58608263e83ccf84920b"
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