class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://ghfast.top/https://github.com/storytold/filmcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "83022ffecdc03adc113d8aaa54e5cab999047a92d0d531821a4681a4751d7dd2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "424b30f3f80b0b29a5559de9cdcfd6738b0c661c3f07510adaf1fc197c726400"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9442156ba5f90ededdf9da1e8583886cfb069046c7e358a0a4f9d19daf7c228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d620f1ffcf374b84ecdb6073ab93894ad0a15cdd76f2e3e8c4330779485a58b"
    sha256 cellar: :any,                 arm64_linux:       "3f125690d2786f97b57ebe0c551b9feee429874533d38632c546038749e4a36c"
    sha256 cellar: :any,                 x86_64_linux:      "755e68e79b624c7d3ce94d4b4bcd38ad9c086ab94fb653679b43878b27119793"
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