class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghproxy.com/https://github.com/getgauge/gauge/archive/v1.5.0.tar.gz"
  sha256 "133204df58f028bf51cac75a3afc9fdfcb6f4e8046f53e8d7fa0387825d0f054"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0574318d0c3e5b86f0e48d4c18b2ff5bac3419f208ee66725fd83dd9beb9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e15f251272b6c5b55eaa09bd89cca9cb8c6f71d85e80d2444e934f4f30f5ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "652872f85e66b596e505969a79a3b76c862161a9e70595276e8a1bc974bb2d07"
    sha256 cellar: :any_skip_relocation, ventura:        "34e3d4b7abb0d2de76c480a59372628e468787f5892826a8b0283f7d6f1e9783"
    sha256 cellar: :any_skip_relocation, monterey:       "350ae8644977647faf57912cee7f306bfa0b0d3f4efab800ed330ea0b5a4003d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2207b2686f2ae1d35d100e8ff201a386ce54fe34f09e4935a22156534b8b1967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c14497317c81b2364229d68636a8115bebd92736bdb8224a47f539990463c9"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end