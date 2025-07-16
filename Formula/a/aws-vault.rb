class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.3.tar.gz"
  sha256 "3a60311322215cce7b01a1426dcd6a724f8ecce90deff8b66dda03f3bca3c7a9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "691e3745492f67012f0dfe127754b80919c717a6b71fa222d1df04e5188b1ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6311d63a246a9d2ca947e58e8fb2eb615342ff798171fdcc484e354512cb61c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bfeb32c93ab48294e24bdc88ca322a91d3ee0d39a04cbbce24a05671a7eb5eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "139b8907ae1af84aad6ef3a5c4fee8f1568aba9e26874ad9f1a71a0610027bac"
    sha256 cellar: :any_skip_relocation, ventura:       "b3b6e4720235f4e4799090aa382408b5c1167951761d1cbb0565ac56e9fd9b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b3caf57c9d48b6d589d50dc005d98333b3e4d0f8df7ef11b7372e3ee9eb651"
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