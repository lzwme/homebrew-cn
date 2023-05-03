class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://ghproxy.com/https://github.com/yitsushi/totp-cli/archive/v1.3.1.tar.gz"
  sha256 "b0e13d073717ac220b4000de0fefe01d48aaeea703887fd47c6d83eb7e0f4462"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf99c1bb1c7017d973c62c6256b5c9d0cecb78116772d793f2041ce849e36c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf99c1bb1c7017d973c62c6256b5c9d0cecb78116772d793f2041ce849e36c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbf99c1bb1c7017d973c62c6256b5c9d0cecb78116772d793f2041ce849e36c2"
    sha256 cellar: :any_skip_relocation, ventura:        "d6a7856f1603c19e3fcef51e3b1a49fec3802b9a14d7363d6c057244f5e45026"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a7856f1603c19e3fcef51e3b1a49fec3802b9a14d7363d6c057244f5e45026"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6a7856f1603c19e3fcef51e3b1a49fec3802b9a14d7363d6c057244f5e45026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6300169c633f0981c1db2dbfe054e53e9860833b72b664e0b151872276b96ed5"
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