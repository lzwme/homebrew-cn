class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.17.0.tar.gz"
  sha256 "36c43320e3c81fbb1e211fc73f7de4bfce55b7de4a97c2026987d795b1c803bd"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7326a6b2d0efaa0393b4261a7d0c4110225bd9bf4e564379fe204509ab6abc32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "debc56a4ec125f8fe8b7148d7e3d345a97767de603f38cf0869a2ebde2dc6fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d626fce942dc521b773e1e2b112b2a8b613f5cccf72c5c247923902eb17bd29a"
    sha256 cellar: :any,                 arm64_linux:       "0295b85d3fbf6c375aeff099d73f8835d43f73eb6666ef8e4220395162051bed"
    sha256 cellar: :any,                 x86_64_linux:      "387998e247a1b4aae3962bf0c73784be2e752144ecdca202929ce40887d2f8b1"
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