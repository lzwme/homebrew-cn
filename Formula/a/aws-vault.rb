class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.16.3.tar.gz"
  sha256 "61232ff6be65ff5217cb002da085bfb00f1eb52e99c68fb6110271cde9308380"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c02749a6c0040482cd7a615d8beab2cd62af4620d68cf27a87af5379fc04eb22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d1a70c39cbbc6a07f66a48541dfddc8635c637a15b4559663aa4a7b24413744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8048584ad035d6ac17f0f8e31b4a60e85ccebc8035b0e400a9d518164c4420c3"
    sha256 cellar: :any,                 arm64_linux:       "4254369c43acf091c4ccb1126d6ced36e7504b86b4f4cd01d4244b38e09aeb20"
    sha256 cellar: :any,                 x86_64_linux:      "965f6037a39749c6f49c92c09c512cf88fc61af8cbe5281f0b589455276af67e"
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