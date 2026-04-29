class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.10.3.tar.gz"
  sha256 "9c5967701024a9193366a16ff42c91941f9a84573c012de120f8b27d95fd44e8"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e993ddb19cb004d05dae86b9b71864510c4f19a1c742300c4adbd52c910bb390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ea139634674de55366ba7cb0d8a535cae64ed27daecc30894653c43d5fb5983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a536a756a9f7c2587c37837eea27f8fddb81020c212a7cce4782a2e997f3bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3dd0d27ec67b5ce11d46d18b5cbe54964fddf68946aa1f00707c0bb59fbc56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aff278581d980e2787571684c205addd614ff7b7c24613e418c357cc302b406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff4663083c52303a7c2f638ca119d0a3439536e9227881ab6650a3678ac7d9e"
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