class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.4.tar.gz"
  sha256 "9682fd4425cb2ecc08ac0e59bfc8abd8bab562a112ecb530c95af54146ffeb49"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ba0d4ae052e9d2990fe99c4469a5fc5740007f7c5f153c3e1d89ff31589979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9197a37db4d065bba48e4452115c8509b75ace7d88fa61b59852c265961f4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ce05ce52541a8891b20b86477d103442a764a2a505ac54e0cbcc756fe3a0524"
    sha256 cellar: :any_skip_relocation, sonoma:        "21a6a50608db1177ba7a31b37d4216d63dd54c55860ad27eac31be2b904102cf"
    sha256 cellar: :any_skip_relocation, ventura:       "4bdd1b530042299b735613413691319e37ca6b7ba91355b7722f1358e2ae6d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3be2ebaf31de1931f7d057a0e706aab78b1d97a06a86dd1e7bc209260d147bb"
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