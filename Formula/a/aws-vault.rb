class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.15.1.tar.gz"
  sha256 "9c1ab3436d58b11b1b30ef759ac4e582a14ed536ea588cff7483c7c2350c795f"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "746020790a850f3f811808b5df540df3ad48093c8b8de6f07517a85a26259e2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aeedcf6c71d86c989191c26a702cf8ba1723eb2ce69d5b6c144e1e817c55dec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b423ad6795e0f22cb8ab02f87b32a9227c76c86dc62e4f46dcffea5ae5a0782"
    sha256 cellar: :any,                 arm64_linux:       "a3dbff35ff5d86586c7abd9cd93e2f1bc8bb78ca7e371c09d20b19fe8a9f8af3"
    sha256 cellar: :any,                 x86_64_linux:      "d29c930cedc7a4352df3e120aca399a9d0c39352f79c36d9ecc91081428a1969"
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