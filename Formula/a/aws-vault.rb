class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.5.1.tar.gz"
  sha256 "d236f2efcf27cd9b03bb557858ebd10fde282eefff7ccc8da2896400f48d6e1f"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fb00c24c1be27a2ff17a6c5ef1d1cb2e0891b46e127bb81d17696a1597a957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "321ae5b60141b6dddabef1059fc3d6c00c51ffec9aafbae9eb3dbaf7c1d430d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e38d6b57f2c0db6752633c795a8d89381543cfc9c64e65105fbe2068c5dca621"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3b64b4fcb2167d8542f054807ffaebfa1a756de8215076f2f8b2238513c3c6"
    sha256 cellar: :any_skip_relocation, ventura:       "5a3a2b059c9327a9506a36efd39e7866c4a5d5340a49beabd00659386cfef560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5eb6414268deee82a3ab0afa723f4140b9642c7e431cd28adbe8b587328392a"
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