class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.2.tar.gz"
  sha256 "1a284c1cd1a7b01725d7121f6f5962e1cc32b88762a840743d86fd9054397183"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbdb46f945ea79b48e4e6790d970cfd13cef89ff8f1d30d3fc0de9b40089f2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46ff129a53593ee8cfd5dc8dd73456daae0997c56cb76f51b1aeace29b4aa417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7becae64b56feb87e16f873bf7e387496cfb9ea5789089e932ecf7e90fe8f1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbb472e244e9c76f154a62bae6958f1dcf1c6bf78281d3607a192483b54d3679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1db699414bb17c1ca927759ec79d89ea575278b045167e362d57862b5d62774"
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