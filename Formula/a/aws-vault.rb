class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.7.tar.gz"
  sha256 "3564ffd0d072a95d1f35509bdd3864fc4a1113681e7bb28e51025f5820e96ac1"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3202842e27d3fec77197da3b545027a41ca41a6758507635a6fbfe39005b72c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4083f159e5b256ae1b16285cb2e6f64c4d0651ee60d1998f27250a658a7e9aa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "011f0d6854dddade768acf0b87375f6b929c8488573c81763ccb67c9b54ac438"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcfc32ddd5a3f9a9e786aba9c7db68e4116e6a46a25473871ea95c1a61c3c7d2"
    sha256 cellar: :any,                 arm64_linux:   "5dbab18d478b05250c479f28b33ef41b39a37d108bd116ca3127535cd5240409"
    sha256 cellar: :any,                 x86_64_linux:  "a6e6b4ba33aebcb4e736d530e6977d23f35bd30fb0c991c7c310c49f2c89cea5"
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