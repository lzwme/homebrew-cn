class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.1.tar.gz"
  sha256 "3b015a948060f0381a1e75aecb0a9ca9385134ff6ee647afa81b51dff813dda8"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f6e572897ab2560cae8b812e796759d041de6cac34b279bf941e8b53eb7f046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5266dde130e66752ad95a86d0e3294ba8c33419a179af8724d4109556205d06d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2753b4e07b92d948b6c08cc1d328e3ff28ad1367cb20a9daa9943c7ee81440c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a02eb2c426247f78e2ed665e92c2d15c09ac6007043c3b2274c9962aa28d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62b13d97634adde87123af2be93599b0491d63890d41ac1fd38a838346ae75fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8339ea81b12ca56c9662c06f728d49f57154d6eefb126b4de2be7edefdb3f63e"
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