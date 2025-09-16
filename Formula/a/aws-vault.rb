class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.3.tar.gz"
  sha256 "70827deca1aaced333f9c01b3bc34a761072ee059ea79958b938e82cbf5b1cc8"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51db87bf3a178a9a6d84adba206335fff9d73e574d49a77ad9271e379da1c0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a814c9f5c4e561fce3dbec50f154187ca3f8d209f60cbbd7caa03620aba4cf18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eab4a8e7dd0acff7a8779fb64055b0f916dee4950dd0c3bd98f7b1fa8667bba"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bfac13d6d189e9a77075628b8730c2bc25bba2e7ba22a937ba64805765f8ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706fdc646e347935808398e9bcc636e026b175fe46a166fa2dfa1b325c27f20c"
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