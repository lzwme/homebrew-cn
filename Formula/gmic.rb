class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.3.tar.gz"
  sha256 "c8444f0aae428a5ed555ddd809c9a4b144b4c9bb29f81057393893c34b1ac0e4"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "91d8b6b4149b09cde106c2f614313692a20f9a82fa7dd42e0933313530967008"
    sha256 cellar: :any,                 arm64_monterey: "63d2791950f99f65500999ab6f133c978b75a5d52c7c266cb22841c45f5fd781"
    sha256 cellar: :any,                 arm64_big_sur:  "1f8e7ceede97cfd66653d70c3d54f22b9c3eebc22d908c8053498c156c6f0f2c"
    sha256 cellar: :any,                 ventura:        "90ad8ad25848e05c6111d20f4688798319b8070b2b283b07c6797d16cee272f9"
    sha256 cellar: :any,                 monterey:       "74635e19170060404e80f55d977cf5249907c8b38e83f35d3a51cf1c9300d170"
    sha256 cellar: :any,                 big_sur:        "cc732d4eec85745c5b625ef8bc8d2a3a365335d8250cfa3e45ce9a1e40ac0397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d976d4fc929fbf82467d8276caab521a415e0b15f7c0e9de5a8a1b129ef19fd8"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash-completion"
  end

  # Use .dylibs instead of .so on macOS
  patch do
    on_macos do
      url "https://ghproxy.com/https://raw.githubusercontent.com/macports/macports-ports/a859c5929c929548f5156f5cab13a2f341982e72/science/gmic/files/patch-src-Makefile.diff"
      sha256 "5b4914a05135f6c137bb5980d0c3bf8d94405f03d4e12b6ee38bd0e0e004a358"
      directory "src"
    end
  end

  def install
    # The Makefile is not safe to run in parallel.
    # Issue ref: https://github.com/dtschump/gmic/issues/406
    ENV.deparallelize

    # Use PLUGINDIR to avoid trying to create "/plug-ins" on Linux without GIMP.
    # Disable X11 by using the values from Makefile when "/usr/X11" doesn't exist.
    args = %W[
      PLUGINDIR=#{buildpath}/plug-ins
      USR=#{prefix}
      X11_CFLAGS=-Dcimg_display=0
      X11_LIBS=-lpthread
      SOVERSION=#{version}
    ]
    system "make", "lib", "cli_shared", *args
    system "make", "install", *args, "PREFIX=#{prefix}"
    lib.install "src/libgmic.a"

    # Need gmic binary to build completions
    ENV.prepend_path "PATH", bin
    system "make", "bashcompletion", *args
    bash_completion.install "resources/gmic_bashcompletion.sh" => "gmic"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end