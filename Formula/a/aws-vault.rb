class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "93e9ed87cb31b3713b39bd302891f02dc791156fea4f5cba44d83f55bf49023d"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d4e7045b5fca27b0b1da823650898c9120c81d95272cfa43f9eb1b9c5534a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10335829bf753150ca012e568200878d20c127ff3899d30076148082822ed33c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aea0d8e5d30cd7bbe782602728b8cbd57f6d59ce3a9a08cf7a854d13433481f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5514ddccf1e7be1e4e9e3eae1f394a6403ceeb22e0d34e40df0dbf712f7c53d4"
    sha256 cellar: :any_skip_relocation, ventura:       "bc059b442632470be79654d0dbe411c401f04869d92353b1a433172cd7d3b61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f2e6a20205e277438842f22e424aaefa83c84e41322398eb48dfd045d777c3a"
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