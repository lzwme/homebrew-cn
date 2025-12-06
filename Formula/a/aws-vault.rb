class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "c7b5092b6207bad3931cd149bd664fe29f0f524a9fbc2760a1988862134583e5"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc69cd5c23c860c0c9f4a747cf6761871030fc431d6747dcf51f7e45bddea88b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c16bb2e9876e36db484a5d282d28a7bbc440546734c3b3dc6d48d439c7f39ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0167bb3ae0f1e011110b76331bd1b02752535a1b6e053f87ebf591eefaec4dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6971933886df21b32d6d560ab25ea6c0dc26328ed679eaa28e5474fa519bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15aa8036e4ae6d13223e5d6153d306e810ad8ea98b2064d33e03ef4f3fa7e59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7e885975e74da9e770f68ae7bb993036e55e50fbcaa86c166cdb13386c27d3"
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