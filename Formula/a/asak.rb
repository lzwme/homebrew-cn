class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://ghfast.top/https://github.com/chaosprint/asak/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "b4d4c99b2e1cf5dba9a9b271815fa12aa8342f1f77587ce5ff1b39098d224be0"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7606897627e570b2245d9f3ab7d8c0c5013054295f7f94903231e1b6172ab7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f922171a47099541fb4b78255841c41c39fc7f34e1cf379f5ef39cc81ce437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3514b8f54bd3d9681fb19bef7b80630994e858aff2a52f62b8adc52a9a8df82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33406e737a078a377554c187c51fad6851d57ef6180842779405d7d034550300"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a89502eb0b2314f5b3c756cc46445d78f76c816901a5586ad094d93f710cfcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95073ac0593fc17f52cf5aa30b32733924c5ce6a9b1da468ebba4787e863dff8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No .wav, .ogg, or .mp3 files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end