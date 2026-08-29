class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.4.tar.gz"
  sha256 "a857230e1e90d44b32468fe18c791e53f1a707e6d958618f96c535ef438f2bf3"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b2957ba816574b24bbc0a66a5905474b9769c24f8aef05a5cd6d9becd654e7f5"
    sha256 cellar: :any, arm64_sequoia: "944ca2aa4e4873616ebc28837f02b5f9ac7bea5da4110c6ea3e8a605742440e3"
    sha256 cellar: :any, arm64_sonoma:  "6bb61200d527d5c6cf77218cfc155fe8188eccf60fe0df3dbd93971887f384f1"
    sha256 cellar: :any, arm64_linux:   "bd79192560e05a02f58df7b6dea546e2c0b6ce563df3a591d4e2f0f030c22172"
    sha256 cellar: :any, x86_64_linux:  "47b0a4286a846b5a1bd1b87802b02ae498884e32c81ff9f1ffc527a363c53f7e"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

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