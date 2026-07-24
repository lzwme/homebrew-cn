class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "06e25638d4f234f9f5bb961ac79f46a8f0842696ea01a2c5150b8627539e4ec7"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d41b6a07370a59441b1004511e82a3290823e0bf8416a060fdbe5170825162a"
    sha256 cellar: :any, arm64_sequoia: "dfb09a30e7d7d44840f2fc6dea6d3bcacf39be5e3c5883f6bdb8601141c3e86b"
    sha256 cellar: :any, arm64_sonoma:  "1cbbdb21a3f0f2d133a795320ff652a021e28a1543aad60cb546ae6dbad8f191"
    sha256 cellar: :any, sonoma:        "e89d0c6ae14ef1c44411d82259f824ffac816d637ab72d68aae8b3e4a37c50fd"
    sha256 cellar: :any, arm64_linux:   "f45814ead7ca25a6b64022a0c6b99dd6f7ef66b5e3a2ae9a090fb625f265c7e9"
    sha256 cellar: :any, x86_64_linux:  "4404ffeff3d1159df3fad2fb35917f1db3c50d103d1fdd129cd0fca2bc3fe970"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end