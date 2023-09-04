class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.2.tar.gz"
  sha256 "1966f8727b7d09f859c8ca3cfa300809fc1c63e0bd76fe5694285a2229383fd8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c36eb979e8e284ea384879d261a0e09159af17166f49a31b6c07c152ea86e54"
    sha256 cellar: :any,                 arm64_monterey: "d12bfd8d4e1cdbb3879ae3ef033133a72b9835a2879fb0ade4325e76be9b8dbd"
    sha256 cellar: :any,                 arm64_big_sur:  "ae383e8e6c61c6dc7284556ab655ea8980cddd59ef31d7aeca002950a49aabb4"
    sha256 cellar: :any,                 ventura:        "603ae1ea99d2a70f014a1506a18c56c69d116a04348b419261563b787fc28543"
    sha256 cellar: :any,                 monterey:       "e7b4e1d1553d46bf49ac59c86b920258b51c84c1cb319cf7aa83b35393e895dd"
    sha256 cellar: :any,                 big_sur:        "1c5985a27c70e5f4631d962fcc1761be390071434860235016865433a99e64e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d27b558709ac2a2280f5f1fa46097fceca6b46ca8c8779cc2993d8b5c8cd63"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    # fuse requires librt, unavailable on OSX
    args = %w[
      --disable-silent-rules
      --without-fuse
      --without-ntfs-3g
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    # make a directory containing a dummy 1M file
    mkdir("foo")
    size = if OS.mac?
      "1m"
    else
      "1M"
    end
    system "dd", "if=/dev/random", "of=foo/bar", "bs=#{size}", "count=1"
    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end