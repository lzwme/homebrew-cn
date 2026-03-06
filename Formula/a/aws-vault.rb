class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.9.tar.gz"
  sha256 "7f77fc8be81b59912097306f27d5ad3b586f4c6169f23c8ca85ba08c442f25c3"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e27e82534b63782f68ceaa6fa023fb4ba73aed9ae8d481592ebf795db26245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c4b6524306d8c76951917bdbfba6a1f25c257fe09fa576d82465a5c2f94297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05d55e4b6da145e69d703e78592d65edf10e623ef243f3e84def18a0afd35db"
    sha256 cellar: :any_skip_relocation, sonoma:        "e506e867c7fb85e2fb127b453f3b717357bbe6627bc14e8ee73783686282d7c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "190a459264cdd2acbc43f007a99dbaba0238688e6afc159f87338a20246d79d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb1ef024d27d0f54cf000decd545c979cd989432cdcf08718128751880e014f"
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