class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "db6d541844163938847286459186ee317dc94459f5cf08c6a81d8e8334fa54b3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da221b14b28387cdc0a5e5b585a254091dc0b3d3d667ad45649df1c94d0f4f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8da221b14b28387cdc0a5e5b585a254091dc0b3d3d667ad45649df1c94d0f4f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da221b14b28387cdc0a5e5b585a254091dc0b3d3d667ad45649df1c94d0f4f0"
    sha256 cellar: :any_skip_relocation, ventura:        "b2249898cfe1ef617e8c43fc65486b78e4a800f261655d1864bd5644a8bf8389"
    sha256 cellar: :any_skip_relocation, monterey:       "b2249898cfe1ef617e8c43fc65486b78e4a800f261655d1864bd5644a8bf8389"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2249898cfe1ef617e8c43fc65486b78e4a800f261655d1864bd5644a8bf8389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89c889070081aa4290cc4ffe35343795aa61efd09ca06181431d9fe6ab6220f"
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