class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https:github.comtenox7ttyplot"
  url "https:github.comtenox7ttyplotarchiverefstags1.6.0.tar.gz"
  sha256 "99ae8b5923720113d034df868104fa70f4ac1d34af449224bfda690a1811baaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f895b7b61c8d9b9a63263ed5bba8755994c2b6a77e3325624b654327c89d6a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c711b65db491d3cc27de22d18c4db28e0c2e3120f6be9ee72d6c785a0844c2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451813b6507e04c08898cd23a51a6db4a844d79e6ad0470e496e0597a1fe3ed6"
    sha256 cellar: :any_skip_relocation, sonoma:         "12b3b4a66772d9a2d499729416fc70d2b2d61a36c64791463c97daed2449d8ea"
    sha256 cellar: :any_skip_relocation, ventura:        "a51810614ef7d50982cb37014fe03b4728e9ab3e5b356cccdf07b520c5d7c1b5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed3fdfc17062a47fcc6da4b8e3c396cfea7b7e45947c4aecfdc7da18ef0641c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c6f08bd3a43fbc24c42681cfcdd9da7f9e194ca5043db3aaf215771f6c7e2c"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}ttyplot -h")
  end
end