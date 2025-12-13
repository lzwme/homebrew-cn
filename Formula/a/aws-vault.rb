class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.4.tar.gz"
  sha256 "e0a429f81169c8f4919f9917429e9ba923f0361b9c4fff2b6936cf85b5ef9326"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d757cc6992c5c6b0073aead70a789826658f1444ac68926446f2faed15fd95e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118a6af4f14a2c5fa235ba92b1ba61e07848a99269cd2195af4aa56642888ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8ec15aa996e8839e6383d0ae6a01be423d6dbcbbc46a10df9cb99ad09d68d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8798bb1aa934455e2661bdad7ca4567b6643200e6c08eb19025dffa40231ca28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff7b6997d1af99f35862dcdced78cf68a7d8d0d15ac6b17adec7a4ad937c37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba7fd6bf09e5d7bf098a009ee746f22778acfe24e2b0daa710903fb9cd60676"
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