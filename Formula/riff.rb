class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghproxy.com/https://github.com/walles/riff/archive/2.25.0.tar.gz"
  sha256 "c0a2d0c6beaab92431f6846a25544b3d63b3ea433e33c9db9aa9f5a5d65f1d97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d09386f67bcaf4a6f19e2ac020af66d766cbc5c343f3756c6f1bddb157e8b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299e42a7edba41c9fe050087c57bf8a2966739a3329a913769978df993121f79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adcaf09ffe83c1f6af7259f86ea903ab94ca697918718c2031c9222e25314fec"
    sha256 cellar: :any_skip_relocation, ventura:        "b69884089048bc768feee9391b7f8f3568b1d6219ffcf1835660ecba5a721587"
    sha256 cellar: :any_skip_relocation, monterey:       "ea15e679f1f213c389031e65e50f78f5391d9b1aa12f34b948b7af7c554bccab"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc3bb5db12712c483241381f22a849dc2887da593b6f5164bde731bc8f5fc77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3562808e67942207f0a46ee7bf591d48ea30509ccfc00e225b6aec3b1c9af57e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end