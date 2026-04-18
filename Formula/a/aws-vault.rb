class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.0.tar.gz"
  sha256 "edfa465a8a6e2b7058a81f6607bb92b5d08d7aed4632a9058d5899a3f238e387"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54bdb8c5cbdd81905b299405269091f89d0c3465a1d7ac80e9c2af2890606e07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a923cf1d675a3517876db97e02fd05c9dd106c26df279957a42ea84835df2a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55540dd46521840a89a97a72e0d3988fd6829ee16879c5799f734364ede5bd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d79de8cc9c29ab4e4af4737590008afeb29d3e4606c44f918a9d5124c325e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9811d101af769b55787f0ebcfeb65d970b157f3953aa09a881d0f477becc9db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0e6581c3f9853b9615d217cb4d139fd149f365aef1f7651ae85c539c1fe61f"
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