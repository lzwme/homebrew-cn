class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.12.8.tar.gz"
  sha256 "37f832d43fcc21ff16b4f570ac1bcbb8ae68bb8c71ce2a32453e8b66221fa9ea"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a506f791827bd1f6faded847783461cc2c5f7903cc0aebdf20336150b232380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7439cb371c727e6a0dc46f7c81e64a0b3809dc4a159043185776cf32e76ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d2bae0e4b733c275048b0c371b5888f8d2450756b69e3fdea5227d3f95bc10"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e47085cc679505270e6ccf4b9ec29f7b3fe462ce06228cbae3a9752de2cbb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b28ccb923a2d311be42a627e5114e5f3d38c6cfddf576e041173c779b6d637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c5a9c707a63cc7cb4960b2db5e53f50a12670ab5267dfc3ced95488b3a9e12"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end