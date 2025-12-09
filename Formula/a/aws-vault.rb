class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "d8e28f91991328a33de9f12e768002adb46c5bb067aa17ab48653bf9431b0d75"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ccce78c8e028b6cd99ed1d0a6d503679253f2aae50046c354a41d410901d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891e3d6cf4e0fe354c7ceb8b24f45ef2215e9c7c381768e20e643a94c1f05059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e4ff378d5dc934ef5744494e48d5fb5afd1e7944b1ee9ebd3dbdeaeb2eed355"
    sha256 cellar: :any_skip_relocation, sonoma:        "d07b297a5034129bbbd45f80ec3be88cbff604a8605b923e6ea821e37598cc38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ddfb7f032aa01d31214974a2d034a64ec7a8febd8d1c31c0d3f8e0151e2a8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da41fc7d4d20fcf66749727528b443744026ccceb1c7a94ef111299d111878d"
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