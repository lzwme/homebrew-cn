class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.2.tar.gz"
  sha256 "115680cfb9d11b5e08b3375722aa3819a947866f4a83ccf7b5ff7cbb647f9412"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "428bc71cecbea373262da0e73f807c5e0953b9df77f0cfda7fc6a0beeae01fe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f832bb025e0f21f0037ad8f67d1e5b8602d54e846606db105263df2e0b8a1910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28a85b7e27415ef3293a341c03de2307c5a46c071a4fa937b77ccb6b5df09db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c51b5afe52b6203a81dfcf2e842a19485622f9aa14ca30fa92c5b10719a3b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "337ee43f623d217f3a7b0d47b2fc43f68df46864daa4b9f92cf5eb31cf237de8"
    sha256 cellar: :any_skip_relocation, ventura:       "3f98a01beff368b7e48444bdf9d7c30c5194db861fb4335656aeffadadd74c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc3a52b5edccfd245c5ad69769d28cb85e19781bff947a250477c83a561fd32"
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