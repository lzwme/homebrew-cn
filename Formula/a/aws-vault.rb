class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.0.tar.gz"
  sha256 "dc6e255c9590b378a322fc669dbc2a369e6f85a14dadd73813afd0027e55b6e2"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba0b9c705bb4caf6c33ba11fb0bdf6b3c49c1c23f712f586531ebae6bf7cd175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03194dd43560cfdea4a23e9edff4cb6c00ee23e757f90f0654d0f7b958975bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0310ff60987b58df0f61c8f353fb29036adf06198d19e42a0384295d75fe2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2eebee2884aadeb53540d509b292c8eb5e6bbb99f3f0b44e49e9bc8188698b"
    sha256 cellar: :any,                 arm64_linux:   "b0855f3ebcdbcce39eb9757cbc242f8f832d1342977a35a48d216e385f89c5d7"
    sha256 cellar: :any,                 x86_64_linux:  "95bfc329bbce7959496e40846d8b12ee59d7a36f4d3f07fda8208e6142cabf61"
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