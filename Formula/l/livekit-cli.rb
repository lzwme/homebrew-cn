class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "f3a4a558d43ab9170342bf587f5bb1d9501368d4f37c454e7be20ba253a24f1f"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7230c09fead4af692965c548d033e22a514f20b19a105b16535a3a7b1172e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897b27ed3f03cf5aa7155607096eff1880306cac8c1106e41a76fe4e8e3818d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeedd7e12259dc3fbc5240d5f9712f09373fff9c27279cb4354151d8145ab57b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0239599de1b6619b896f2ef67b36a8562515c6ff4c3651cf93520a67796dc044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1d6490c0b61bd457c132d3c0a93e129fc19603b074102ff5ab14fed6d72f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c287e865e69ceabf7966c718025a54393fbfb3b552c2d839f11196217111be6f"
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