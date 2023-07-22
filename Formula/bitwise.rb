class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://ghproxy.com/https://github.com/mellowcandle/bitwise/releases/download/v0.50/bitwise-v0.50.tar.gz"
  sha256 "806271fa5bf31de0600315e8720004a8f529954480e991ca84a9868dc1cae97e"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85b482536f160a726ccf996c7653763a19c43b5b4926c8da4af4bb0b01ff63ca"
    sha256 cellar: :any,                 arm64_monterey: "7b2980226d0d6d231bf41898bbadd6c18a838bee766aa62dfff1c451d8c0357a"
    sha256 cellar: :any,                 arm64_big_sur:  "92f12631e0740195ad3cf87b0a320288d6d27523651568575d3dedb4a02a0705"
    sha256 cellar: :any,                 ventura:        "7b67229824c3f0e7b1ff3f3e1cfbf11f8f0b8f6dec64a75e010e81f1e8e32fce"
    sha256 cellar: :any,                 monterey:       "5f880e578cbd7558572c25c9f5c66a674e0e0547f1bc7e8cee33e4869bb39228"
    sha256 cellar: :any,                 big_sur:        "560ee93626732de20fa8d5ca16058c92f26383a497e8218029ecbe377cda5602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843a3614b4b1ce32529429588fbc60289bfdf91086658666c850be7f88c1baca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end