class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "464b0bc72db9766947273e8b0170a3df7c3017bbb2cb5e2431afd13973db8743"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c36cc181c358dc4e5a0dd35d788e3a006480ffd1acd425480b7f6109af8384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee48694ff57ca658c6e30f9be9520118da393d5677b45991e9a97109eb64d220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d5aa57d3bd50d08d0ce1b20b9497e5779f33ecaf05720b350e1c26aad3b5cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "87bcbcc47c7e08ed0a6e0b74cb12274bdc7c95f9e93202c15a7abbd5897c2cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f019c49e800238c2910486ad6f158b8bf0ad59955af04ffd880fd55590c259f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84cf7a21cc9dff820095b8a352a088d78bf4506859109bb8118022543e4f38a2"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end