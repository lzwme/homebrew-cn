class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.16.2.tar.gz"
  sha256 "4d6b0f262294a6681c45dc743a628bc3854a5cc114160fcb19effccdf08eae99"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25bb8fa294afab7e27387a650aa17bdb6ea2c5e9c2e3b03d2487f79d44f5c678"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6a9ebac890a213d62d91831d983ba302a76a3ccacf3309541c31050eb419a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d09614686d8cadb0d9e0673d6bce05ec6cfa9532698b32132a2542cc709f720"
    sha256 cellar: :any,                 arm64_linux:       "a77963ede62b407cc9ddff57c61e9889e5e58bf9647514222ebf535e29a81736"
    sha256 cellar: :any,                 x86_64_linux:      "a21f06211392061a233f4cb370fc2880b0543fa415f9db7b02b6df9f8938bc3c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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