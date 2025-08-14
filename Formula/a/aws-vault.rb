class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "9f8b27cad594cf42f41b9adaf92de6d69e4c73ab2d9e122eb1dff075de00a48f"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8074c094e1e89c7f121d7f66dca3f8c55e498945a06edba03b4fa08aa5ceb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e23ccca1e1f6f2012cec692e5d07be421a2b08fcbdef41a45b95a5f79d5de53a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1f1979faff7dea64bd1fd9178564d6052286187c3b1be63f1278925c573e4cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a08e525a89bd1b9cfe6747e187ea2bd23f6514361387dd1ef6a417ef55b655ae"
    sha256 cellar: :any_skip_relocation, ventura:       "b4e1300ece991d79b2a2c4658576cabbe88dd1e84cc85765de508e12365aea61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d08537513954e38e6fbf71e5bc31786fecbcff571d50bcabf29b1978dc7288"
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