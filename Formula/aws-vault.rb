class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://ghproxy.com/https://github.com/99designs/aws-vault/archive/v7.0.2.tar.gz"
  sha256 "b4de78755ea2032839ed5ae1c69bd1a7b09eae986da185163eef190f8e7896da"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19adfa4b1b7586fd9764b77440ede7d8ec85f372378fc0f4443e77b5432446b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6848429d084ab122bf065669db9e82cf8630581f3c88cf97593847f0217eca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8877c63f822ce4abee6c4813c292367310096e9cf3fb3a521fde3185abac03d8"
    sha256 cellar: :any_skip_relocation, ventura:        "a6b4df7a563a6764e24a553b7417db5322b09cbd5f29d783f976ad14eea7fd8c"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1835619d053093692562e78913be1932c370799cf3fe73757eabafb14228d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cfb1f0f4677d1de3e650bd532cb3124952b4def38934d0db0c85050c983964d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e393f4f974368c375537359ac28565dea07d38075f48c069699c2913332b00"
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

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: operation error IAM",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end