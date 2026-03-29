class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.9.13.tar.gz"
  sha256 "555c51447262f3c352ecbec87cd18416950aca54866eee3138727cd26bed70fc"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98a3390cf285f7ae25ce6d6797fd079f501b94099fee6b524aa21f8cc8d3014b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621ee59f1260142086cee7924d6bd5c518f7a9a717b812d58916bde48e7f4667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8822c7df23ef4eef74591d7a8b6bacb7e0145413a8b234641c34214be94a10"
    sha256 cellar: :any_skip_relocation, sonoma:        "a011e4186ae56606f0ca7a3f94bdcbe3ebaca4bdcfc02703c8c1b9ee0a90e8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd15a5f8cd408611452aab93674cd0fe67eab49158ecf929f2b0cf4f8e9b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ca12fcf745bb70b6df90e39a753f60097f6c33fc72d00a68ee05a8854e1a57"
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