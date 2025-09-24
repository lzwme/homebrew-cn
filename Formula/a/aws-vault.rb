class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.5.tar.gz"
  sha256 "198f2a26a3be60b9e56644b60d5b9cd4ce2d48c86e08724b400c132d6792b63d"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ae4f2fe41be2e3b2c831b011758b1e61f68ee6884d8566276ed8fb3d3fcd686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e0d3d1201a305a4ce90026650a11ec1697898597eddf0fd9af44c31116cf69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2beb22690981ace20d968cbf3f3a44cf1cab1a2143167cf3c1b9ab5ea391c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "25388e514798c27d452cc5533a294770ff66af1f01a900ffd381cf3b78013656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf9cb0f19b847198b77cf38955f3256a0196bd4f8e9ebd9f8960924629abb79"
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