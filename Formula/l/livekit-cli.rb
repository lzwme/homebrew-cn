class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "92f45dd477002470241eee7bc1b7a3a83ef76da6a09f8018b79310a58cc5fb46"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e19f5bf3a8db3093a2bb7604742a4dd025268890167152e0b0ccb61647f749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a71cb5e2798b0a7dee778e4cdd16b869935cc69df39fa839b75ad7f0696570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6ac6a26a9726806ae54576b31aab2e6e374acd49e20dd58059b4a0ca0f64bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "800c4cc44d25b3ed24c372a5803a93860b68d4215c11318185a7b483f94b28c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2152d4b31f3cef68b420f9617618522e4c7d0db76856a7e2f32dbd76b1bf6a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4c9f1dc573c6eb151b8cb4d2f354eb086ab6b32b125a4310cc50479cc9cf13"
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