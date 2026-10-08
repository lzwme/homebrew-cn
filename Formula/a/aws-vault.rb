class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.15.4.tar.gz"
  sha256 "737a4feb4493832f8170289989e71fd291b8f50a11af803837dfe5e2037ef9d3"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a322d393f72995fbe23a54346f42ab2171c781f6559fdf47e898d167bae8d7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24bd27e85731ea2aa386079fad2a4bfc9207eb365e88fde03673c8108e2a0fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8135ec5a8d97e69e547bdc0e4d0315e1e955c18efb8422fdb5b039efeff1e3ad"
    sha256 cellar: :any,                 arm64_linux:       "a262e12c8075ebadbe345c13c169173f2da4cc52abe31bfad4e3b3f8852fd36c"
    sha256 cellar: :any,                 x86_64_linux:      "db5ed4c42879ee277065d9e4027b1179bc4be203b3cc62fecf9a16b7dcebd324"
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