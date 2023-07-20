class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://ghproxy.com/https://github.com/doy/rbw/archive/refs/tags/1.8.2.tar.gz"
  sha256 "efae806ccce17d2c0ee827558a2c5f772fadc524d8b5d0b7262c8488325c2717"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d081d9efb3f9e5c81abe82cc93adc6173d0fe0a93b4678dbee5beebe3d69d9c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e65691110aca26b58e4a33cde923304362fc9debf5408a98e1f617b66fa3ae3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa376a2ca39b83bd27ae261c5ff23bb6feb6966cfcb213b4bfc90d0e82b16e62"
    sha256 cellar: :any_skip_relocation, ventura:        "950cb3281d7ca6961dbb73698f9c973c3006cd9369cf65add2815f77370fcf7d"
    sha256 cellar: :any_skip_relocation, monterey:       "793ff2017359e497fb2b148b27d7206eb73254f67f9b9af3d108f34e8fd9d0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8d2fb3c7624dcbc2366332fe41ab6af3038486a56714be99ca6b7c8a07f63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74ab1cb85a9e2c6d81c8dd0ae749d2b5f473bafd4c944c81dda1f6b28222913"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end