class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.6.tar.gz"
  sha256 "98b63163911fb43e579cd3dba2fe29e41313e713f46bdbcb6d990ed3ee8d11d8"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c839e64556d2459c7c5dbb98be0f9da7ddb78b19a5637bbbdf153bfb969698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa3ea7513c83d5e6b9777df5fb663b3a80c31c10932b4d101f9d3f49d2b3d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e08b726e3abf7b9ed797807eb5b5b3a52b8a803bdac3f349872dfd2ea957a734"
    sha256 cellar: :any_skip_relocation, sonoma:        "7610a33ecdbe26c8dcd2dd28d11258cb1beb90c90e297529ff25b2e3b13274fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5311290dd7cdc1bf665948f2ef303578e29594d0cf1119a4ddf974ef0a698d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3908725615e672fe659fb50868d324a2f38fdbfd9b6fec97c80d3e7ebe0ce660"
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