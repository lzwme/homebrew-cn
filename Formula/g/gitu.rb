class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.14.0.tar.gz"
  sha256 "a6142c15904655768512df261be0673c89690af8e0b7e5e20ddfb356959957c4"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2eb6a40574ce53adbde8a4f7c32bea52f939ada03529807b5b667e2ce144437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06a64670e233d63bfbb70d77f01bdbcd8a42a181bb9a6b6c4584fa9a8868663a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e25b1317dc826b8fe45d2909872972e4088a5c824670fdb8919b00092a4104"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc9b284f866a5c0db45f972c2c010beb071df332088e0fba0e8245b936a4dbea"
    sha256 cellar: :any_skip_relocation, ventura:        "4e7d12c2ffa036d68d4ec70a639bf0884cff730e2b5701ed1586173ffb04341d"
    sha256 cellar: :any_skip_relocation, monterey:       "5a47ba90a10743a3a08659971a56e88e2077fb2205919f2232e040ab58dbe9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68a8a940343a68f04f7cb3a72840ca227997cbc337cf99da4adc885a7a01942"
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