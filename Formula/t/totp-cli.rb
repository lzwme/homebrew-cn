class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/v1.8.0.tar.gz"
  sha256 "fe218f172f37982dd7623e2183f5b511616dd1ab407cb748b3edecd2a0b8989c"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2e7d6b7134bdb474d260520da82dcf9fa0bed95eb3ffc5f6afe937a951e4504"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e7d6b7134bdb474d260520da82dcf9fa0bed95eb3ffc5f6afe937a951e4504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e7d6b7134bdb474d260520da82dcf9fa0bed95eb3ffc5f6afe937a951e4504"
    sha256 cellar: :any_skip_relocation, sonoma:         "e84fe5aa95178324a99529d6251491aabe49a9dd2f3463e507cf2fa1e05ad145"
    sha256 cellar: :any_skip_relocation, ventura:        "e84fe5aa95178324a99529d6251491aabe49a9dd2f3463e507cf2fa1e05ad145"
    sha256 cellar: :any_skip_relocation, monterey:       "e84fe5aa95178324a99529d6251491aabe49a9dd2f3463e507cf2fa1e05ad145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33658bb8da6979203270e9b15706313bf998fe494b6a8fe62716395fec5bc051"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end