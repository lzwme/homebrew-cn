class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.6.tar.gz"
  sha256 "e3699576f276a55511ee9dca72af4f09edd2534604cad00a041024f83c1d5ef7"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fb08e83bd9f69d0afa5c3adc3c8dc51c606239c879b95b7811c69d414045543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e468d76460becddbf17fd072ef1f251ea19503b6222063bd21d4694638b1fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c200662e44df9e22352d2f296be962f78287a82f4727eaae11658c2992d0d875"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc1dd4caf705085ff65bcfe9459aac8c200ff2a34ea9599fd9fd2338cc4d562"
    sha256 cellar: :any,                 arm64_linux:   "433a0ae81e8fee9484fbf6d57678919477d498cc11b6f44ce7a6a7f34c047997"
    sha256 cellar: :any,                 x86_64_linux:  "8cca0eceb676159d0f9f77c40a860b63ea09add4793642070d9964af6f6ca269"
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