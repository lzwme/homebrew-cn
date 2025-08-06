class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.6.tar.gz"
  sha256 "6b4d84d16a1707f62d038446480c4a9f259561e3c60244203c5ed12c146e7efd"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb429d862d6b7b963fec0cea0453bc50abe5cd2f2297f2a663e39d5d8766c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25fa986d8d4f680bcbf16253a1c4110a087743ba5e6c6ce46dc87e417d751b35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a1de9dd76bf1de73c26906ea7730c4a7b7e644948396fabaf587140c9f0c11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0116a6e5e1d51a90b0baa1f5c378f0b8ad842655df056e48dde3e787dfd5efa5"
    sha256 cellar: :any_skip_relocation, ventura:       "877b55d22ddb8609458163d8bd7e3ad2be75f6207cb45e049405d1a7d2f53e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2447cb80d83802b004288d3fe771734e3b062db8101cc3583fdd4139224ca84e"
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