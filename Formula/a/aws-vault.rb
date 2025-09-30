class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "813d3c1865406d543a31e5183422a7f3acf97664df7787e547a974cc01918f3e"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5109234781816b1c29eca9cfa89abf881e89edc1c34fe0bec25b133745743d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc756cfb0fef172ae4f0987b763c7804a6354825e280c297c31267d83c1f051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c84d5cdb2dfe327dec4c0445417f1fdc44341339deff863f3fae139f87ef8a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9221e7726b604ae2f474fe52a87c54d1fdf2143c96a4144b8b13f01d85d4405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aff115076e1d8b22909d9449489fe5f45761aa26c14872dc638bfaba13bec2e"
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