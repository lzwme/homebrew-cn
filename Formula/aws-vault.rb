class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://ghproxy.com/https://github.com/99designs/aws-vault/archive/v7.1.1.tar.gz"
  sha256 "dd56d8dc51afc61c3474496a381d8b422c1faadadf1f1b2477339239fcb7d507"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcfc42a550fa7ee78d554058fbf95ba76ffcd40e1e3923c1b2ff372f75b338ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b3b185dcd5fad7d3e43ee6a938367f4daa431deccd201e93dab931c2f007d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d698402b9fd5722d4c75c9f7a731cb7c47c05e9ae0093abfaece50bd068bc471"
    sha256 cellar: :any_skip_relocation, ventura:        "16290ee0b488a7a6481783249b68c50b915ce313c2c6869d891e9b06ebf069e0"
    sha256 cellar: :any_skip_relocation, monterey:       "549266f88d31dc34635254f4010d6e3465e87c06145b319b629ed57f5ee6dd4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "421d1a659f549412e7cba7eeb538e5085622d2b5b469afa1125bf48c1eb1f793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d340cafc143a5b8b089cb5ee04bbd40fe5e9b71eb0efc1aa121a91c51d50d43"
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