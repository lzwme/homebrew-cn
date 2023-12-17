class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "bcbbb061789765a9c28ada1298a5e96039cf176107f657e6d92994d05db6c22c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ced218d716e7fca692da52a0f2ba618703a4b22d7723002b127caf03ec871e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ced218d716e7fca692da52a0f2ba618703a4b22d7723002b127caf03ec871e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ced218d716e7fca692da52a0f2ba618703a4b22d7723002b127caf03ec871e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "92e8548d02a45763b58b69e0570b021f76a93a2c9800865a8e00d326e6ff008f"
    sha256 cellar: :any_skip_relocation, ventura:        "92e8548d02a45763b58b69e0570b021f76a93a2c9800865a8e00d326e6ff008f"
    sha256 cellar: :any_skip_relocation, monterey:       "92e8548d02a45763b58b69e0570b021f76a93a2c9800865a8e00d326e6ff008f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159469345b2f49586f4e15192b5776ded2a45d7c5ecf21ebb1c2bd2e8099086c"
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