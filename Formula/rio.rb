class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "94aa2565e26fc8a8c5f22b1442d6500969c037c321177b065db06b0cd1f9544f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5739d87c61094eb1b25155d4fab04abff702964bbc3898828b22fbf8c0419c92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f17d9383ec11bd6b07717d7d8f09d6b0c62b25d284432adf072aef2fe0905ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c867a9fa8ae8ae436ba7428d368174c612313b89b5b866773465a4f24585e3d"
    sha256 cellar: :any_skip_relocation, ventura:        "6bd9e7f33414ab5b5fac5193c942ec3bc71dd41f4faa814b329fdc9c28169d78"
    sha256 cellar: :any_skip_relocation, monterey:       "c3865701d457e5086c02b708fef14aaf2cee422c853b5782b1ac5648a23c739f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d02fa48415cf256f1bbb563dccf32e6cc09f777286c6abad189c60d00adcab0"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end