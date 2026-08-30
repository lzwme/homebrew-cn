class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.6.tar.gz"
  sha256 "84d282802cd867ea37dde7824ec2628cbe19f599b3acd55e73cd3d6f6cf244de"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d2bdf35d6678b4a66803948bb0a366836917ba7fbc4ef85c1fd106b5828ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac8e0448989a337be87f623891ab5d9ce8e8da5b7d31fe977c96c55e547123a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "764a3ec701dc1ac594f5714ccdb49226c56a5c704a9619f010a4e0c9fe9dbe8f"
    sha256 cellar: :any,                 arm64_linux:   "05e66d8d53c8e3ab087e6ca81c50ff8c696e58b67f1eda3db25a2d78aacc13fc"
    sha256 cellar: :any,                 x86_64_linux:  "60aa9423ece90b33abf3f8ee7aabb272d03af58bd8303d80eb4bd0ca452af0c8"
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