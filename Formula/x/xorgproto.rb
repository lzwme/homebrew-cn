class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2024.1.tar.gz"
  sha256 "4f6b9b4faf91e5df8265b71843a91fc73dc895be6210c84117a996545df296ce"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, ventura:        "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, monterey:       "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1ef8db0fe244a7a47541fe8494131a281814a4110d3af41d76226274601df7"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end