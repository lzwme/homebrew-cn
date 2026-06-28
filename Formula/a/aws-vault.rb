class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.12.4.tar.gz"
  sha256 "f1c5ae09608bfb16b1724089e0bcebe4bc56fc93037dc80245759d7ac88144c2"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e6c8cde376a66399e1a1876a5c6b2f4ddbbb851387f6595d47d7601d37c4bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5869f77a2c39c31110b043f2dbdf0bbfd238921bd79e89900bb5804c3b4398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dcf5c6d085d46565549a9832f2a3acb4740637f14f476dd94d52f51d63380f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0cd59f592e5cbec6d98c41c47c656862f144ae610e9cfbad82b01451f045bc5"
    sha256 cellar: :any,                 arm64_linux:   "396d78b1b408d54669f58af468cc0746830d6479f0ae757060ca55fc17c71d64"
    sha256 cellar: :any,                 x86_64_linux:  "1fe9f2dfa60c3fc65906acd9e114812172ca82e779dc4478747b15ca21b55d21"
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