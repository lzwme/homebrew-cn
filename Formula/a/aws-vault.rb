class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.2.tar.gz"
  sha256 "cc28463175ef133cc7f3c2af2deccb0dbe344975ad8c04c43f1da6e87f26d3c7"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0544192ee3addd848a621b04b99c5eae184192eee9388592e6feb6c631871b68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d44f52b3cafd21f591fb15a38dbf416c762c4a70fe797229d62b82e1ac0bc21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2f725298126cfc859c422c34ebe31acb3e58d7552627c0ab30f80e7cf2f5f90"
    sha256 cellar: :any,                 arm64_linux:       "d6ce5cc773c6edbe066fce8a0bde791488779b44129993cef2795cd506ba7048"
    sha256 cellar: :any,                 x86_64_linux:      "535edd16b08ed1f48fb730a76eeddec40b78fcf9e28af440436f70a51b0b159a"
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