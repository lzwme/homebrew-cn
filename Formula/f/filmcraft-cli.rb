class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://ghfast.top/https://github.com/storytold/filmcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6ad642d7e6cc1ad95bd44183ff00813ee978eb78a983fcd38f3f98336b8ef4d1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10327176255ee492db7d90b9d9d052176d7b46d07b3615baf761a404cef7a535"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3371d421867f99486a21f49e3e82821fd4ee9391ee1ffa1fdbc16fece4c68941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7c5f24bbd5c70a08bed8fc0e5258270a1f8778255d890e5ca28b67257dfc61e"
    sha256 cellar: :any,                 arm64_linux:       "4eb446f440c80ab4147cc1e850fbe0f1c8d1449341806b15e9393e0ff01fdb0e"
    sha256 cellar: :any,                 x86_64_linux:      "e49e0b7a6ec21ed5913f99826abba1c143d705ea580e341c1516397648a5e02f"
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