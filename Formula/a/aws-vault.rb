class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.3.tar.gz"
  sha256 "1909d62ea7771bb68a783436cdc1d74f0d55b8ca8194cb556ad1795a898ace49"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d985f5466f48fcff1ba6eb95049184f61f07366606d1b6b5135087d44e77b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d6281397042319e866c692429bf6baad35319b280083818067af4623805f7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db820c806e633fd4b251eebb77f89ee7afbe28a00f366d401913fa00726dd4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "95f45e585595720f3ce762899acc96b01efad1b4617fed626bb385e9c8f938bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aed462964b5c18144746feee774e68ffde6b121215cad97ef7ff36b624ac0c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f85d528e5c5c368eb5cb60e0837fe3be91b119096142a561592bf1bc54ef83f"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh" => "_aws-vault"
    bash_completion.install "contrib/completions/bash/aws-vault.bash" => "aws-vault"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: unable to select a 'profile', nor any AWS env vars found.",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end