class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.7.tar.gz"
  sha256 "5b566d4db8d7a3d48376242cb92445fa9778427ee8a8e04089a267025363479a"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "360222f14e657a78cec0246e579b3ccfb2656d45b1c5bcadea42126df4bc7c89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e122a2c73cb395fb6d31324f98b2c18becef327c02b9f7fdc5377dde09f707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5130a56ebb9cbba0a17142f64c9a642f932a8ab0b91290c1381b4d72b0d8d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7fde477fcc952008c6d533f08fedd15bb41e19dcb395c617fbf53c67d4b818f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e1ac3940804d2673686937d03533667eb0f497b9bffc20017d2097eb1603f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72499d3ee7a69956917f7a9cb5ed16ddcfbc9e193429efa7429b3fe43ad9c3c8"
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