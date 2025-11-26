class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.12.tar.gz"
  sha256 "87d50a784acf8f056ddaf42439bb414d300322ad661a866153e964b03a9a4e93"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbea97abd24d8a7f06f560f944a624b84fefaae37c7ba2c5f2ff0935c5d4b4b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d2d7112b73ce81851f4bc19a2c64573e276a5a93fdd61ea234ab8523fb7c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4a509464777cc3a176d185daab76d6d183166a60050756f1f75c37a9f3d6f87"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4e40ce25c9c38ef992ba5801c985ceebb377618025603e8737bbacc5e18639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d0f808415b682a4284c4eb02febe1c72170b87d4abe3ed87d60eed767fad749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20f078a0177ddedbfc47c828f136c27498d68d47c1c92a4e78a813da093b7c8"
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