class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "60681ec04eb6479eb1645115ae985444afba354e803d5c4942e6f27721e07645"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c04d193c20d0906adf91cb8e61d2a6fc63bfe9d9ac784476ed0e4a95a2ba049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383c2e979a2fe251a0d6590de022ec8de91295dada004d4a8ccd7828b46f514b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264c7197a68320bcc6e0cdeba9055d6fddb67d69a48d884793d6b1f431c915f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "32c69c94ff4e5352d347ba4c8b64e11d791629c0001a806130c5f95b55ec03a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79188fa0f76c747910ba8fe712be75e474d1b2fca421ed7fd2858c1681b63dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13e3fb1ab044131ec599e50913b51e111a70d92ca10d6246de9c188768b65b4"
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