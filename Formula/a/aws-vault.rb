class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.4.tar.gz"
  sha256 "1e734443b5a9041c9a9f08ba2a1c30f2c62b7ab2016ee0d907a6a88d09c83ae2"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68462f1fe14469ac80b5d765db5626b98577494cbf30921b38e19c9643e5adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76eeeeecb0427c108358632bfef9625f245b8363749ef97e1cb3b6c6f438f808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c377e8edd50ec6b04306ff4fd092659d882e5d44c3c5588b1b61e5d9fade53bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "123daba22a981c7c5c6990ffc6a63d46520ededbd817608e022cd30a183fd7d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5c62f6bcfbf4da237204ed5ac6a0ff77ae51b58815fcd989cd73a457cf26f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346d3d081308c5c1a825c7c0e9ef24a68644a121c9645b560c9e6a3e1c325d8f"
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