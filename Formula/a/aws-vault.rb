class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.1.tar.gz"
  sha256 "7ae981b7c53d88e21565d51a49f1021eead6eabb7fa7bea5fd5f13477b8ddf4e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50829df776f14ff55e15777b7e580c057c76f5abf96cb673c79da94c560ddad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a019973e988293fd4ba3ef5e9b8ea0f412f1153ef258d67a288525408be38f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "633a0ca85c93546eb901db3b047cd588e88567e47f3a8e1a2a3d7d501826d0a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e003b1396aecbee1f04934c90355ba490625636019d16f6ad0f2984a3d913be"
    sha256 cellar: :any_skip_relocation, ventura:       "56e0878bbe035eb873d15163abe7c0b075faa470ced4a39f8a254c2eeef14b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5318df0ed3d9af25347ee3b1c4bbeeccb6e9f1e8aba094f8aad6485f62c0fc58"
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