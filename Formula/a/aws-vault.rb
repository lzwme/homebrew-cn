class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https:github.comByteNessaws-vault"
  url "https:github.comByteNessaws-vaultarchiverefstagsv7.4.2.tar.gz"
  sha256 "9e4cc6cd1db472f25abe059097c8af2f5875d44130b85d076d171347ff7cd93e"
  license "MIT"
  head "https:github.comByteNessaws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "641fb6cdd8f66ab75385bf01b6f5874c5aa4fcfad01b16072894f85f99cee45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d98a596132b8746c4af2dcaf30040755d9b96dd748b838fd491b68aa54af73bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7b08b6942b2bb13c747c5b3c31469b4af0fb3169e47c4e661ad856e9714755b"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d8982a55216b1a1019a976864f0bd6826b1cc34384412cbfb4a6cff090abd0"
    sha256 cellar: :any_skip_relocation, ventura:       "3903f6a40a6f73e03906342d2a01cb3de39dac54f7d492c1fe4027621972ec07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d692e20389f50c6bc1e2851fd9e11795e861af27a4aceb16968e0573534eac84"
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

    zsh_completion.install "contribcompletionszshaws-vault.zsh" => "_aws-vault"
    bash_completion.install "contribcompletionsbashaws-vault.bash" => "aws-vault"
    fish_completion.install "contribcompletionsfishaws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}aws-vault --version 2>&1")
  end
end