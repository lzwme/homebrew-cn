class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.1.tar.gz"
  sha256 "dbe369c526df46ce5d8eaa1548023adfab5ba22d3f4f193644980b775345aa6d"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fb4989ee2909d5a6af3e8e8d8b8b331883923ecccbb55d63128dc0157793639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04f27f01bedf260054d5f67b1fbd2b0af697304e8db4d3cf5d6c07cf0452d6ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f82b27b24983befc25d50fcda5abaa10c44fb94d5190e8d324fbeec16a90fd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f18f8c12a3ad67b790b5eacbbbac7f9b9dc95ea0fd65035e7a6e9d833d9b0350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4f39eb5b975c48c55f03b7c5ea5f8268996bd8c13743b54c178cf9f042e20fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e845deffadc4ee78f6d0c3d0bbe56c8ac9e7e6da6dd8dc02f3bf33dd2d82853"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

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