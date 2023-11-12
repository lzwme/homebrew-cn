class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "b30f257acab4c1999b2a991dfd0da3952d69676a45cd1db55cc4b0250a0855ce"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62692da63908b8cda2ff0e3c45ef32220bfda08ee0bc3a60268af0abf247864e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62692da63908b8cda2ff0e3c45ef32220bfda08ee0bc3a60268af0abf247864e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62692da63908b8cda2ff0e3c45ef32220bfda08ee0bc3a60268af0abf247864e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dc6fb2717a18e409b253896af849d540d75a09663e372ac64d765ed2ae37bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc6fb2717a18e409b253896af849d540d75a09663e372ac64d765ed2ae37bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc6fb2717a18e409b253896af849d540d75a09663e372ac64d765ed2ae37bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e680a42316ef38ddb9888daf55ca5e0aa22ce7f4d53c72b9a561dd6f8b793b15"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end