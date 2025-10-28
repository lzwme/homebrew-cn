class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.6.tar.gz"
  sha256 "d6f51eb3afb7bfb6332ef991c0cace658090c3cb47837aac7f4574a57c4a5779"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d771b9a8543a01a30984c1f9ae5e77e4627de50164ef78a88eee01beb7d1705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e79c989c2b276ba7f37c6cfd4ef5dbb243b41f151c261bfd5cdb7be015004d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42380055b53a27d83446fd25e642d2b232ff5b3ddb4551fbd5dddda433355d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "801f068dd94fdff3ae93e64ae65226bfd74a78cb744c397c7c027aab87786b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a34c25ef031a2552778227200be58ae4bd219bfe69dceba88fd2ff1e56fd61f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c67c526fe32834d348f964605144e8763db9fbedaaabe9645043db922521407"
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