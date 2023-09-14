class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "f10f6e7793f869574b22d0819cb84ad6e7a839513ff0efc0861b4cb3c5a18080"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c7e613af43c73ff7d47e9d00bb1d73f0cb3f4b9aa50e1dac07aed97267e298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c7e613af43c73ff7d47e9d00bb1d73f0cb3f4b9aa50e1dac07aed97267e298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c7e613af43c73ff7d47e9d00bb1d73f0cb3f4b9aa50e1dac07aed97267e298"
    sha256 cellar: :any_skip_relocation, ventura:        "71bed5ae2a1c7ebda885ba9b45c162fa14e50d1b93b8308147bf03fa41605541"
    sha256 cellar: :any_skip_relocation, monterey:       "71bed5ae2a1c7ebda885ba9b45c162fa14e50d1b93b8308147bf03fa41605541"
    sha256 cellar: :any_skip_relocation, big_sur:        "71bed5ae2a1c7ebda885ba9b45c162fa14e50d1b93b8308147bf03fa41605541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d59c64f6034e3729fc7e4bb4ce723747bad33ecbfad7ae1358a39e8c426e15f"
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