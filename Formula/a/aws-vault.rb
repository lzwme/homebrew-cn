class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.8.tar.gz"
  sha256 "8b9c3b11e200f5adc270320d7d128c033652214db2fe7fd11ccc424aacea0710"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd5f9c32f9bdba5144ae4c9bac62fcfbf7705c9f2b655aa33d9c4839ffea325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e4a63b5a071b4b6c416c217fb339958637f44321a15120a30bf861c8c072ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "680ba6aff07304d5821f231547e5fc8e37f5dd978deb04c7c6ea486ab86ee783"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7199345756616ca5e306495823860d1e8588639ed90e1ef61e172b1934d5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7696235b829fc438c6567672fe01123ecc638b97ab3d7791b1dffbb591e830ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d25ff10fcc59a679d5fb66d1d67c1ac90bf523d163b1c1459a9bddf5bd71c10"
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