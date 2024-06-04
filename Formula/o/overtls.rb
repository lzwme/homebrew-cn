class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.27.tar.gz"
  sha256 "5d9f226237b6cd324ae35ffd7464b4e580bde59bad61aa92201de01fcffec773"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70f1140e719d07dc35fed113aa7638386ffc63c52e2b1980fa9c6bd0573ba145"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c159142e1f6484b5253cb2b72a599f7560e6430b0013c0a008a796edb7e131c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829893661aad0499a110fc32f0ccd1d23009453c6ee402c1f36a27fe905b0dfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e486e04eee7ed0ad700c702da2a08e019bba5d7c55c014022e64ea81f60b041"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad0c899b61546d47c53cb530278202c42a3d1c69fd9138302149bc2356d12ee"
    sha256 cellar: :any_skip_relocation, monterey:       "60f942a79a45f554c6282e9f804ab2766b8cbd501d2d79a158d0349dbfe58486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66710844038b8716a44a1c7dc35317409e6dd2b051bc8b61d1ac41f38cf801fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end