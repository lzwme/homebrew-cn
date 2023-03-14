class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://ghproxy.com/https://github.com/99designs/aws-vault/archive/v7.1.0.tar.gz"
  sha256 "d02d170bf0b1ae1cedc35e843c1653b657c0f68297a38e6e4b833795edee9b9e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0ee332caa005937511ad59aef47258edc0d715f698af9751b1acc720483c7e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131164dc2462c045fda257d072128bc1873e7b651dc0a5db50fadefa690c55c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75d6278b59739f45281ba0b1f99ec20d45fed3a900c2196176385e9e2228b0fc"
    sha256 cellar: :any_skip_relocation, ventura:        "8e3d67f3c9dccada77ba918695a96d0d69282db3bc5f76053bc0891adc2705a4"
    sha256 cellar: :any_skip_relocation, monterey:       "c6fd5676e5cda5650bc1a7bae7c7c0855b33c798c57d49723c7583b266ea6825"
    sha256 cellar: :any_skip_relocation, big_sur:        "445e3fb03bd8f9c90b588b39710ab0b5772b0b37d1a34f7f1202b3ae729a2518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a822874a8bd4669fbfb68dd26f4d457d1d206c2e7c820cde9d2f2cfea3d92a81"
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

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: operation error IAM",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end