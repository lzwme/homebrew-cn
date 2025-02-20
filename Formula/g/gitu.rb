class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.28.2.tar.gz"
  sha256 "6ff5b7caac401341ae5b2f01749e5c2ab49ab2a44b4e1e139fc2e7601223499e"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a661359988c38166a22b5a1cd2f372e65acc6e2fd81fdd334d8338496847b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742d966fa2247083051fa8ef4df3d0ee91de80a38f4bf4b40fcc0f8bae76eed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ab2aab5e9ee419f64ee102236a0380a41678ee545bc765402f8996d54937f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e640a1bc3d4841ed5c3e083fb30ef01144b9cd8b0b9a1313c79ac45b02e5ad19"
    sha256 cellar: :any_skip_relocation, ventura:       "d2c113b919890dcbadbb16515e31a7b7fccb1cfc5203e32caae7c8f1ed9749fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5c0ef5e9ae82a2b3d8e2b8833183bc52a687aca8f4379c9dfe1c70b3aa01ac"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end