class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.2.tar.gz"
  sha256 "754401ecaa247905190930d378c7698b8aab6d7457145bc98953eb9fdac6482d"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1e1e21acbcff1eaab961f92715a1b771b7267cee6a5ca102ee0f0d34f25f46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2bd7d61b8a16a9b39a45cc9cf51659d16846c6d6d03c16f2b05bd07c9dedf86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c40b45922253ac264b12d7ea5a8fd624aaca2036fd9d095b74573056f78f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ce3650c7725a807f1f768a01d79eca142a8e274ab77b2732f167b4a19b6525"
    sha256 cellar: :any,                 arm64_linux:   "686f21bc8f10ba45534e6f85c6b1f0fb8f582c548f3a74caa92e14ef5c3ca3db"
    sha256 cellar: :any,                 x86_64_linux:  "d9a1599f2248394ce72e7cdc1bd2fefcc864224ed02223c2a74530dd9381b1c4"
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