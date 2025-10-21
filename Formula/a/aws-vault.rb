class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.5.tar.gz"
  sha256 "566ba82cc9122ca6a292cc9cbfe9d10b3fa35f39574352b4e822e950677e565e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d06df57d37e23963d752c50ae7698cee226249c2cf5cc41190c65278acf07cbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305712e1d1dfff7e520e848289a7fa9324aeed0fc474467e2a17328e6fcc01c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63150699215f2d90e36a08942d5fe9d18c59b10bde6d3c8f556e679b0844c0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b893ab7ed6e16c6c5c22e473dd8e6f1e3e7f278442529c80dd6d0a5dfbc70eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3766c85624e85b9724cd13feb630345cfc4b7d4cab3c3067e7bf9b47babf42e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1374d43b6f63e78cfd6816a2d144b8757441f9f02823d610259bf8e37d00de1"
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