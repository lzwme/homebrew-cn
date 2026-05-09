class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.6.tar.gz"
  sha256 "e03ec70f66caf0d7154d7ae8748077a3a67b7ec2c7298597d901de9e5ef5cb5b"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0472829eac13fa9e7f88d5198676e97eba0a99f9f10804a4792ebb56ae3f4463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6dd05c4fe08d3c9b1f3ca1f6efdad3586f4783bc215c3e9c141bd5fa1b4407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e415d840f4e83b8a35586fb4a558c4d1b3aba72e87e2cf7d49804b8d4950baa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "434bed734290126555462e655df93600ed11426346ce11ff5a9e8f828154cb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdde32300507a4a7c88a5f38ec5fade1e2d69f063d8f4fdce1124f4c95be0378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362d58eabe922d5dc4679fb2410561ce4f6bdb11129dd50906c04446c5245e47"
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