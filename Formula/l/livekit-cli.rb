class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "7654844eb98113ce170475dd9a5c82b83264d97668bba3178fdcbba211df0c07"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2db0c95f57a60b18349a8cb4a3290f77fc5a2430f5161190f18c48184a01e3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd1a2f4bfb3cf57a2e9e00ba9b8011834dfe00bb3200f7a075d0e04e07e6fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2408be81f0fba42c8be12f71b21c710783ab1f1f5f4814803498eb61608f2228"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd2415d81a65dda7c77c6786d5d77ba2793ae9d4148b9099415a0cbe1877da6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d48b60700aa18bd7596a18c20882a3f72efa6429c6869901273e3b2983c659"
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