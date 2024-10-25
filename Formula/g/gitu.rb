class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.26.0.tar.gz"
  sha256 "df581bdd293a7e9b1d0f6ad53a33f327f147b0cd8c5de3933a1aa967923c6c25"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bbdcd731b6be2d1af8762e055dbc749c4025c8d899c3de01d5186474e9c5fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128dd846d04a05ce173a058dda0ebb1803df6c8754397f996c7c728caca3e32f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e8d23e4c40111ffcaab9af077cbdd4e0e8f86935451cc7b4aae87ee71a86ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f0b5a2992f43a0d7bd50c927fe7f212c3c76c292a3da90723aa12e7c13f684"
    sha256 cellar: :any_skip_relocation, ventura:       "24079560b9535ab5032af3146f7a055961953c8ebd6f4f1132343211ea83c86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38b1f78557a8af07b57408e0d4345880b1e237d8ab93a0628cab018f0cdfd967"
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