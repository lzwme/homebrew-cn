class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.8.tar.gz"
  sha256 "db9aa392805ffbdd0ae9372edf1a94b0f17bbaa9646bf2f58d24a914e0d5b737"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "14fdf8d5fdb7415348f4f42a252dd2771f5f82a9b3a60ce482d06447d416d08f"
    sha256 cellar: :any, arm64_tahoe:       "0bda274df85e177fccd2dc8e5768cb66d55d684c514ccc6640cfbdfd17f0393d"
    sha256 cellar: :any, arm64_sequoia:     "9de5d483a190e3efc9b7ef9a97f33b7807a959c44de61200d37329e3519f2561"
    sha256 cellar: :any, arm64_linux:       "07b50d42e35bf2ca103361cc7d7d1c2a385cb6724f47e56512436c61583f8545"
    sha256 cellar: :any, x86_64_linux:      "107139323a316eedb3eda5f586fd1cc990681c9b8af876fe8983d0e90a783e34"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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