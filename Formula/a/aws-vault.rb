class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.10.tar.gz"
  sha256 "a4afaa2e4a822f5589d1c63071c70eb50059d7ea3e6a503e3dc96711dde4a095"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c9350eff74a7b3627c91abc645eb19667f881e7a5d431e7d562d1d3c2f11f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91ed0eb58949b8b4e455ca25b81f6d7d6fe2c4a261eece5839915fb63846e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80daf2fc0aeefd975911ff9887adae80d9dbf195f360715733b39908e8aa5294"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27179f329e1d235624edc8cc3ec535bc6090e6add24ea1164521cb10743423e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf6ce8ad454f1ac28df92f89e159ea8aba5509917401893907bdc5950126278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d58f7100ffdefc7007fbe5a7471f0ddad9ee795d1efc39b460d007de489deeb"
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