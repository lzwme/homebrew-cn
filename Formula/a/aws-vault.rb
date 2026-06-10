class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.1.tar.gz"
  sha256 "ff60781aaf5378aa4600c4b9989c6d3e3cbfa0454124f291c8b0dcea8f0c3c91"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a022f862a9402bc7a191e97343c0376f53b5077b2e4c392b8558d47a7eb728be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3f72513a1b9fbab2d0603704386fa0ff31a860deb3f6c9011ebf5c7490e975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1523ece94faf10afa44b49ea1160b09dac50e5b4bfd5e819caad701514934f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2017246667a795d15bb61a9c3cdc5f3c8a8fb132f671054b10c00a6140f2835"
    sha256 cellar: :any,                 arm64_linux:   "ce1e80241acc18f3dc1313bf9fcb907fab461e1876d2808856de812bf540403d"
    sha256 cellar: :any,                 x86_64_linux:  "86aa27ddab4fe01ed0504a3b1edc8518edd6873f25c50ed919c85b6a1d389084"
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