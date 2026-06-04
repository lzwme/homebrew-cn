class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.11.0.tar.gz"
  sha256 "e39d7314a278f9c4397414d92a78e34af9b97f0f6dc42fa62a483c18a05e1ae4"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12015297722c27b348f0d0098a852ae93f7a1d431ad515d5217194ca2661ea12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53665da806633f27e185a9d8a2bb9fc79bcc70d66ebeffe33b4a3c741b1cb9eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7582452c807f4212417a4d697574f65e166f271985f1fc6e865896e86af7b7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1ce53c450e3987b9f4a6f9eff14e685b2eecf5dcf772d6d098650b20d7111e1"
    sha256 cellar: :any,                 arm64_linux:   "86a37b8325dc3a76a6995cad7d3b9510c3f5d0a53f381d8f228a0842425f0996"
    sha256 cellar: :any,                 x86_64_linux:  "e704edddd5240c54a94ccac110a2d7d4f766190e4eb7db6d74769729d1e6aeda"
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