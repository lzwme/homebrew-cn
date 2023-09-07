class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://ghproxy.com/https://github.com/printfn/fend/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "61f28950e5195669391f15c258e6c20cfad4ba45024046538ff8543d08862833"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e53a0339b4d049cd0cec68cab78372a2bb716cf8697ee911beb788d4cfbf8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77468429914f817763e7e4067973e3a1ee70ac8c93413bda47893cc69c6b2d98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "649c668543e088df3cc126e6337e181c2c428b10d95d42283924ba4c08094eaf"
    sha256 cellar: :any_skip_relocation, ventura:        "760a59b901f3e198b052a5db6a825531a459549f49a871ff6770be268b272456"
    sha256 cellar: :any_skip_relocation, monterey:       "4c4f479d87f9e909338d331c6cfb91e89144adda6fe5c8b020c926b182af28d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cfe7bb6edb96c084581a9cb43d984de1d813a00c0c97c9ab030f57400edb57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dfabb17014733b65d26472f8de4156babfc60218cfecb416711769d4f4bd417"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end