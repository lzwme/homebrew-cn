class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://ghfast.top/https://github.com/storytold/filmcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6b5ed01cbb1328bfb7c702baf58c7e68af156085a6ded4998ba95b4ebefcde5b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "088e3cdf77c6ea5f2381f1d50a90c3ca93b1ab87de893d32df980063aa1b9ce6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "165da8ad78ba5555d212b14ed426f7b31d54c3e10029c401fc41bade039b97a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a04b2ad3a413fa92473eb4c206fcdd35ac9943b3ab92b7a08e873b3d886a5ceb"
    sha256 cellar: :any,                 arm64_linux:       "308faac427e45b88c7b6f5f8e0139f1bfd4e58590d6d0c84595a65010a8ba9e5"
    sha256 cellar: :any,                 x86_64_linux:      "f4ec2ddbe2b7269452efcbc12d9783e8887c66b4056c0b98a6471706ece93e3e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/filmcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filmcraft-cli --version")

    system bin/"filmcraft-cli", "--demo", "exec", "file.newBin", "name=Homebrew Bin", "--save-as", "test.fcproj"
    assert_match "Homebrew Bin", shell_output("#{bin}/filmcraft-cli --project test.fcproj inspect project")

    system bin/"filmcraft-cli", "--demo", "export", "test.wav", "--preset", "Waveform Audio 48 kHz 16-bit",
           "--start", "0", "--end", "0.5"
    audio = JSON.parse(shell_output("#{bin}/filmcraft-cli probe test.wav"))["audio_streams"].first
    assert_equal [48000, 2, 16], [audio["sample_rate"], audio["channels"], audio["bits_per_sample"]]
  end
end