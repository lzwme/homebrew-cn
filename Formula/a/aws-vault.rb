class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.7.tar.gz"
  sha256 "349790f4aff5e1797074a33e444a6543e722e48bc1e6dec3a18a8626b6b85b68"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d90c3461c7a469ea9d369e8f87e65b25b529d73d8534dcaf86e2efa585abdb15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc07c24af09a1ca5d400215a36c6cb4b878765298dcf71fdb68fc1eb11c3691a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ebe5f59b23357149900e8096cbe318a4db527dcd2e90b7dd71346eb89a53516"
    sha256 cellar: :any_skip_relocation, sonoma:        "a955338c260acae42c044343a769eac8f33edcc8e40ea47bc0b76bbe1b4b4386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c01a4e5afc5ceefaf7887a67174bbf21d38b2b169cbe328619a1fdd407adc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe9710b54c857d6a43ed9553788f835a95991f3469e8fbbfea6effa0adad2c2"
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