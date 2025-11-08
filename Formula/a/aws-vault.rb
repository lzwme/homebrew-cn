class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.9.tar.gz"
  sha256 "3abf6fbd5d328cf9daf92b614a30b5741dc6aacadb4ad87726cb2fbffaacb415"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc13872d2707615675f0d66090d2aca4b0d2e341a2333cb1503e73bfe61c9fa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a6d8b90ee87f3fbbb3f8141f8d77c513fa04631c76c48c78c24a06372a8861e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a437dcdedf9736379a6fb52891af0aba27794291ade7c1fd227f12ff657b183"
    sha256 cellar: :any_skip_relocation, sonoma:        "544bcdd136658225a8918d05e026809963467e2bffe65194589d2127393a808e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e510e9581b3845724b990a247d9ca8076c1ec49960628c2b4be91c646312eb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ec9800dfa190b1b7f7bcd2af3a532f2c418bc359fdc531e40a88d721710655"
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