class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.5.tar.gz"
  sha256 "ae1a903df27e3131702c27b6fea6bdd8faabd756f53e22d3f35fb790f22d2035"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3aa015040f2b0b9c2c8d63feaece63e5cbe983b18af05a43a8026945ad7763cb"
    sha256 cellar: :any,                 arm64_monterey: "9d6cb858acd64e8182b397c9a2fb0c672bc6a329cca61ad050db1dd063575185"
    sha256 cellar: :any,                 arm64_big_sur:  "654fa0b8186b0fef5a31edf5767402a5206d4a5bd4f63b1934fe5b196efae865"
    sha256 cellar: :any,                 ventura:        "94c167ab435bf9740a396b5bc00e91868408c35d764bcc82f3b0acef7329b7c9"
    sha256 cellar: :any,                 monterey:       "91b2361bba4f3e6bbd187600a2aee0c9713ec95730317364fe852838fe2a14a1"
    sha256 cellar: :any,                 big_sur:        "a55c0c43d8330f75440aed3b178eaa105e22cd92c2716cc992c6b83eaa308999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303bffe2d5940cfd9148bf5c854292e6ccd92012ac4bbcaefa5902c399e6b365"
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