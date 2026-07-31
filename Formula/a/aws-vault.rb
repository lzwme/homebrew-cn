class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.2.tar.gz"
  sha256 "4f970bcdb71ba97c6780d079caa16e71bb68eaa5b9b34e22ff9d654a1328a9d9"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85c32914f69b3cd22236044d3c9df7be0d304cdb6ba4028f407fe4cf62f8509b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358f9bf23f163f1b0baa8330547fa2a6b986b4ee6177248802ce17d1d1a19637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a4028c9387568de8e7d5f3659c580ce6f465c28c246409d3d2924b1677c5d21"
    sha256 cellar: :any_skip_relocation, sonoma:        "c510352a403bbf6027ea817a8179ca84344fee942ece6fc4c6ea685e1d2d07fd"
    sha256 cellar: :any,                 arm64_linux:   "0318072fc5fa58394a46fc00320b6c5ebbe1d8c1bb1c9929fce7eacb339e63a0"
    sha256 cellar: :any,                 x86_64_linux:  "d0356c2c915c8e8364e613a246091103e7b5e9cdb721fac34749313c91ee9e8b"
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