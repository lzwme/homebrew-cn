class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/ByteNess/aws-vault"
  url "https://ghfast.top/https://github.com/ByteNess/aws-vault/archive/refs/tags/v7.13.3.tar.gz"
  sha256 "17cd4e75c76ac04f0c4aa1709eed60644458e916668fd25affd138eeceb4e657"
  license "MIT"
  head "https://github.com/ByteNess/aws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a10b355e03e0accf502cdf2340c8d13be277c2a997c7467a67707dce997f8d40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73514ff8aa56c3750413bbc686427d3ae41381fbc34a83ddf557beddcf494ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7380241d55122809ec4818b682cebe3d6178219b53d3dfdb241c19319dd71de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42bb59de3d4fe3c49bf980664aa7fb52ae493967073d20efd4081ab2e032b1e2"
    sha256 cellar: :any,                 arm64_linux:   "9b1b401b5ab6b43952a20b56e20a146e1e2dbc235e92f76ebfc178c205b5b47f"
    sha256 cellar: :any,                 x86_64_linux:  "54b987cb0a132c383d645630e0b0df20cfe2c7efe6044d146eb8b948a11359c4"
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