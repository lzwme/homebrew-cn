class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.19.1.tar.gz"
  sha256 "b99cc5ed1b4293d6be77629629d173cdd3ad99aac9b022d55779ea96159cc152"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75e664df239b101b0f4491f1e2496d66726b7a42d015e249eb5c2249f840bd37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d949285029ad162815c67442e5aebad0dae187263ee23ac10771f9df12d4da5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82b6541984b925998b63e94241b71274fbef4582c7d16a066dbfe0b3411b5bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "bccbecae573386e01535d11f94a165ff5b983b47f7530baad16e5da9eceeb547"
    sha256 cellar: :any_skip_relocation, ventura:        "5573485f584a39ad58ffd89582bbd37fe87589cd2b25ddd188d69f512ae22440"
    sha256 cellar: :any_skip_relocation, monterey:       "9f59c6cff7ab56ab585cedec29dabc2889be8f404a8eefe491353d2d5babfd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23058084e65a915965350fece86ce6bcc722ce1e6b263574dc07f7e8a86b1124"
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
      assert_match "could not find repository at '.'", output
    end
  end
end