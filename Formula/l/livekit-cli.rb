class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.12.7.tar.gz"
  sha256 "93642976f07dc8e08369d669360b2243152a2cdd8854787f2a3cf5162b5dae25"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c0f026ec16f3150dba8da5f928ccd8bcf95de5662cb95a09946f822efaf50a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880d2ddbe07ce7913c933294c505df7959ad6656cc12753fec3310980e40a5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4f703eaf49898a2b60f00ef8a34d2bc89492f7a41eb9e3cc21fc15d9bfdf4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93a9a6dcd487df83127e9c1e876221629d117d86e433f5a9795bf91eb0f06f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6aed7b3aca9d192420e49ac1356babd4ad8872f463ddb57a2e748df00109e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600ec39c063cf703a6d489513c6736204ecdff516bb801ddceb363ef9c081149"
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