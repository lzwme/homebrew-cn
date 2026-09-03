class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.5.tar.gz"
  sha256 "d8517952ebf048f9bbb4056ab69fa1adc909c0cadea1467b5541857422d2510b"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31e2b77fbba577d154354b7e1fdc7d3c783f5efeebbd4e49f396d56c0e994523"
    sha256 cellar: :any, arm64_sequoia: "e8762580fa678c96237153d023c759dd5dd2103a8f5ce3fa8e4d354fc87e83d6"
    sha256 cellar: :any, arm64_sonoma:  "d3aa7ab3ff28c2a9501ad0606153a1ecbf083b4526584eb9435719036e6813de"
    sha256 cellar: :any, arm64_linux:   "5bb257097fd9214c052f210820f1a9c3b36f2930c872de149f1414a5273153fe"
    sha256 cellar: :any, x86_64_linux:  "8ea89c8b4842acb5427eadba17b0c65830600f7781b45cc87da63f4df8247075"
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