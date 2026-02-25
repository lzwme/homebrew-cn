class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.8.tar.gz"
  sha256 "7aa8b0ba06d588c52cd556bd9d9f1c53d23ac915d41478ef2407db01ed242d2c"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdcdab43a46b8d0418130592d6ff6c5f68911c0dda649ff37e2b10017a1d6a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ef10e321a9fe575403dd6b7e56701e8071f3ec419018cc8bc7a4f3c0e88875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4642a9d28cd37774ece55ade2c752405d1d59d551eeb6583b5dc25b780a70fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5be696a6cc0db2619a413c907f491ffb119aa6cb47f4fe2c49c6258e0586d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c239b3ac8e13899499f7179917579d44638ffb157e87d97289e196fed1f3b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f470bd7689205d4c877426fa50b1f79fe59f8017b5aaec471ee8d555d23052a0"
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