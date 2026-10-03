class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.15.3.tar.gz"
  sha256 "89e0872b5cacdf7d4c21ecb44abceb5676ded57a0be8be022b49e971067c3a27"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eef0e8d62020a030a7adc757c0d416ffe1747f0ab1f5c74e4946818bfb2d3343"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "783b38df6ecade46f794ad7957faee1b8151458d4b5f9207f0afdf4909ad6e34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7a230ae6381c3310a016d3e551cb685ac1a11d9ae4b21a03ec3485d2a6b6f63"
    sha256 cellar: :any,                 arm64_linux:       "d659bedef930672614ab1b951948c559a681f7ff97da7c7f799094d3a1b1e6e6"
    sha256 cellar: :any,                 x86_64_linux:      "07a3279fcb5cf4106f6881ce7f24e9d2851ca95de06776e4cfb2555f7f0a37ca"
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