class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.10.tar.gz"
  sha256 "1f8b07621adf23ccf105e2669d300cd5201e2e5aa21308aa79f7f46bf3058338"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5308f0fa4a286283632b76f6737c42cba55f5c4eba620c9d63620f8d77cf1ec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c90d7da63d3f222e169ab76265cbee33a35b477aeb422808e22148fb0b1fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71676988ccf678bf72e60be9f9fe896cd2bcd2faceeae98f4fb5fd5f515947ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "01ed7978ed4aa23a933a6533d1e9c3acb2515eff20b87f99d194ee6f2e0d1ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a243c603c43e3e8d5bc3ed9949f08629a497a97e0e6d4ad56151479ba49865eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302cc85a27b3ea30e0305daf76fa0c05d6378eeb72f8014f7c748713b1efe913"
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