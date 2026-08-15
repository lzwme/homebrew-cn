class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.4.tar.gz"
  sha256 "7372e1ed8f9efc86fe667788aea023094c137393881a302f7f10b2a1563a57b1"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e72a5203a4a0fcfafe7aab1ca49c9e8db8c3fd8fb1d0efccab9cf9939ac6592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a163215673f171e723ac44abccfcdef365f27449e9c7bd94ae7f049944232674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd1d298ea41c8815d8386731fd0013a95bef24e288f10adfc2e36a287732950"
    sha256 cellar: :any_skip_relocation, sonoma:        "68e7656dfc578cb24f7078c7b7d8aa901a7247d1076c21a03e835d9edc801b98"
    sha256 cellar: :any,                 arm64_linux:   "2f402439e5db58b27a2ac73a678fcd1c1fcf88e775e5123c8641b301fb8a7493"
    sha256 cellar: :any,                 x86_64_linux:  "cb61c2df099be0de428b03e7b34c0f3674ae5d5fb1e04a22e12b436917b12cb9"
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