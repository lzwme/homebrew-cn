class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.0.tar.gz"
  sha256 "06a2228e96355be1804431c74f539769d1bf8bfbce755d57709f38e711f005f6"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31f5c142d3b4c474c606d367afac90a39e8fb2001416ed6dac695cabcca658b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d2b0e3dc543e99aaf7f79c45a8bf8da8c27ee4be6fc3c78f14adcae79d789d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95c5e9bc1366480916b3357980081734492ab3c114d4e7b0b7d70b169a1d61e"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e4abb3e5592d49a5a19b657af666d06ab692e69221629e6fe78c849082e3a3"
    sha256 cellar: :any,                 arm64_linux:   "6bd39b9126302126d5ecdf878531dcf959e50342fd772a6ff6d5a7bd23d00b54"
    sha256 cellar: :any,                 x86_64_linux:  "3c5201bfa8c20e2e045e845e578296a7c355ac0a0d9c0c2eb563b304f88da607"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version}-#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "."

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