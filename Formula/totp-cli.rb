class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/v1.2.7.tar.gz"
  sha256 "a7b9b2baa3603d1a354f382ffc9c4bf5495c6648c04636f81e345cf46497370f"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5224ed6bdc5b05e54ed6b58f331cea7f801ff753b7546191ced0d9cdabe83e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5224ed6bdc5b05e54ed6b58f331cea7f801ff753b7546191ced0d9cdabe83e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5224ed6bdc5b05e54ed6b58f331cea7f801ff753b7546191ced0d9cdabe83e2"
    sha256 cellar: :any_skip_relocation, ventura:        "a7e3b93bced68c494f1ac8e0d39eb25ed25ea7ce34db052c7004d432d0902f62"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e3b93bced68c494f1ac8e0d39eb25ed25ea7ce34db052c7004d432d0902f62"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e3b93bced68c494f1ac8e0d39eb25ed25ea7ce34db052c7004d432d0902f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f1cde0cb10aecdfd3208f835a7b97a523355789c39ede0085a4e0909ecf165c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    zsh_completion.install "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end