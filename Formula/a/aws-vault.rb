class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.5.tar.gz"
  sha256 "1bc70dbfd372c92d58e434b27a382a2c1273886951f74b54bc8a28bead6112aa"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b96b1b617ca244f7418de37522adaa6f932f1bafeb0c54d28cc2656353cdb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b079e9c401324fc5d39d36626b44435ca27271065ed0b48567ac414cebc0d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e81818ef1887ebb33ddde5c7b367b1e165e2e88a01c6b2611bc6d80182c8d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8030ab5ad99b3dae8f81f6b55b9c6f1e642c032ab5375d3dba26c9c23874bd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d6303d3e402329eceefb29ef3ec62184099b567497711d349dd9338148982b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4058779f136d7b70e151bf66d1b30b0ab58a9cd13ef1198977134cf0260e2d2"
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