class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "010400e74f1ed362801d55bb7efb517ecf0fe73bc84ea355404d5c32907484dd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7960799485fe2844077801d3caa628926597cccd0ed077556cb6228eaeb9eee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7960799485fe2844077801d3caa628926597cccd0ed077556cb6228eaeb9eee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7960799485fe2844077801d3caa628926597cccd0ed077556cb6228eaeb9eee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b43d806e31703b9be9b29167dfef145a6f0633a9d92bced2423cfd611319f323"
    sha256 cellar: :any_skip_relocation, ventura:        "b43d806e31703b9be9b29167dfef145a6f0633a9d92bced2423cfd611319f323"
    sha256 cellar: :any_skip_relocation, monterey:       "b43d806e31703b9be9b29167dfef145a6f0633a9d92bced2423cfd611319f323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5d183395e7d81d5548957b9adb0bb789c038cd5eceb986514edd17fabd6d76c"
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