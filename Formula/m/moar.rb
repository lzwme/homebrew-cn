class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "ba3840b57536fc39ada112836179d3c6c6aa7208e8805f5db2bdc59bf69a899a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22c7e603c4633f251789fec22685a5b1332f59931f46cb6b3d563009a8ca745c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c7e603c4633f251789fec22685a5b1332f59931f46cb6b3d563009a8ca745c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22c7e603c4633f251789fec22685a5b1332f59931f46cb6b3d563009a8ca745c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cde6d22dfa07beffd02ec72ddfa75c043b0816a99bdd20b65a7fa92e4bf3e402"
    sha256 cellar: :any_skip_relocation, ventura:        "cde6d22dfa07beffd02ec72ddfa75c043b0816a99bdd20b65a7fa92e4bf3e402"
    sha256 cellar: :any_skip_relocation, monterey:       "cde6d22dfa07beffd02ec72ddfa75c043b0816a99bdd20b65a7fa92e4bf3e402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d592bcf962ffc10ed917ca9388470b6c8dc789cfade246cf771668d412f2fdc"
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