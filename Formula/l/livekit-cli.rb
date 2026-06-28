class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.7.tar.gz"
  sha256 "6c8ec5740c0c56f207e40ca9de149af075f1bf1d2429e81965e73a708874a598"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "669fe08125c360b2c4d499e10d039f2e9d6d375837ace393703799e69a531840"
    sha256 cellar: :any, arm64_sequoia: "88b9c1089a5858dfea68a263e74c22df1a714b0a042d34e3c16876c1ea6cf84d"
    sha256 cellar: :any, arm64_sonoma:  "100c46f42f0f936897c8e45767bb2d7817c8eb2ff9596defb3b8a810e54c87ed"
    sha256 cellar: :any, sonoma:        "cc3ed14fbcca1d848c294d7ce4bd4ae40252b79f357f2eafffd5ef6f2e58bcb4"
    sha256 cellar: :any, arm64_linux:   "ba69b29224e6ed635266021296f062452a4555c32f615b01fc97e28a80c72c30"
    sha256 cellar: :any, x86_64_linux:  "cee608ef04c1fbe87af49b1cac72c738f86dc8ce8418933548e05618e9a9a678"
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