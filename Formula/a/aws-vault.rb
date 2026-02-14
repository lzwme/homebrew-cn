class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.5.tar.gz"
  sha256 "dbe511602d42c24756d0c0e29a582a3cfee0de3ebbcf3e138307e8935a2e12fd"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98667343f1b702718719de12ee4e9292a80af30b6a6fabb12619e548b1bcf195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640c8f2d5ade17bceee20b875f46701795419c4e48b96ddeb988d0db4bdeec2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbaa7ca8372c88d5f9e65f4f11e783a03e00c72477fa72fefd846b20ceef200"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4ce8a988285cc3964776c1234fe6433ccecb3c50713701669dc964036a45ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e2f30d7e05f41a9e57a3eb88d60b63e9414ee7bf445d07a5c84a5ea7c5dc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f9096696dddc4a986b79b12e08509096f2e3c663e6321742aa6c5533f40b39"
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