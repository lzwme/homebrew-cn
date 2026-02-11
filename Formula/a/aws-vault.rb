class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.4.tar.gz"
  sha256 "fdd9705aad93e89a6a7c65e991b38be9442bba5ff7380049efee1509a4b58c43"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41773ceedb863d2e24e42274bfee525b9c9bd83ce4d89fdc8c573652cc5c80a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d377387993588577dccf4db7ddf22e71ce64b0cbc4863ea9a03b9b1c9809b927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faafe4464aa24746c212c20e8d7dbedd4e46ab26b5a66b2dcc7c538ece55e680"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9092cb6bea913c34c3953e7c49eb84ff4d43b23541313667f1556d2ca66d72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c468c818759f3bcc2e985c40203301879fb0c2caeaf521d326d80e048eb3e46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158adefeaa247d2131352bf75c5eb73eba3c1e3d335f0daa1cb6c7ab6bdf0d2d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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