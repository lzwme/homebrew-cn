class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.15.0.tar.gz"
  sha256 "0dce8964d9b58e67ec9fa83e8eeed78a3425d602bcecd6c2bac0b7d21583f9f4"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95c9fb1e61879dec35f23f8d2781dd923c9fc0b39356c9b51e3bc6ca588d7a3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69f4311c52e05f6677f43a6efe12f2622a928e08ee9069fa18490205b20dfc78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5b445ea8ce5e475ad10b21ac15bc43fa0430e896504b56f2fb3c73575566b80"
    sha256 cellar: :any,                 arm64_linux:       "0f7dfcf4dda00b4aeeaa38857f1802acc9a75990e5323797a4857f432221dc03"
    sha256 cellar: :any,                 x86_64_linux:      "a643ef26fedc52bc2687a620b8f3e38b056d47f443b3112b912c3095d1cb39ae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}-#{tap.user}")

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