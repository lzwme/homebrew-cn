class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.5.tar.gz"
  sha256 "d18152062df68e4d11b5aacfe290248b2f89fcd3ca0a528c1d99038b298fb3e7"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bef7a114390af5a1c2a32f77a9dee2a2a6c066537a0d3d1921f47b6267fc300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf0731c998622c91e5f72048a5f7d999c7216ce0a5174fec13dc6228b1e5910"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cd7d611697c860f720a467799388f35ee4f9dd1f1754c1fe9da5d902ac83026"
    sha256 cellar: :any_skip_relocation, sonoma:        "32236f13fd5924db036f022735280a564a7f550c1253956bed9bf783aeaeb866"
    sha256 cellar: :any_skip_relocation, ventura:       "4a42ca63cd1b9a5671128b2535a36316cd41b943ceb5be52734569cd9e16b607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daf4be9e4c2e89f845ac778e2c47762056058ca04a98bd6d1225d6f7701e698"
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