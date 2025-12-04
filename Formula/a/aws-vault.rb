class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.8.0.tar.gz"
  sha256 "d2326e9df296d105d06a937bf3402dca4b610ed502a116c50e39359083fdfaed"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e039375782fec79a2e1ff0716fbb0de4f1d075e5b21a3768e9edf9c3106d3ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1fd870b0c9e414e9d429467639b5bcff750916be5fc7ea740b1b82f9d40438b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f7af5994ccd5ff93bcc173329199c643057e6a96c886ae53da18a5ad3d1c268"
    sha256 cellar: :any_skip_relocation, sonoma:        "c409b5e1ede48cf4a935062dbcdaa29a176b3acc0a5b62c7f22849677a8e8709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "565f3574b149e8f2f59031861d57bd59dd7bd1198b8411585ca3fea432de0689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8f87a708a84de0c752f2373397cdc0498026ccfdb79839c09021df361a0c07"
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