class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.3.2.tar.gz"
  sha256 "d95ead2339c552378cef2947e844d5ec247f3a8485471786395aee10f566f868"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eufilessource"
    regex(href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39a4b2ccbb2e3689f322907e298d8390571b8e89243c7fd19d367d043728c97a"
    sha256 cellar: :any,                 arm64_ventura:  "69bc50715e25757418299d5093f8b254cb14cc401d0b4054b72a5282b281811b"
    sha256 cellar: :any,                 arm64_monterey: "1912c7b84eea4cb446b6824bad4d6cd65c97032b744a26b2b1fbe23048c64022"
    sha256 cellar: :any,                 sonoma:         "21e392f64194d8ca1b9fa247f6f0e78513d40dfbdfe4782c46cb5e1f42e58a04"
    sha256 cellar: :any,                 ventura:        "3d5d3fba99a3c8f34086e72eb84e496d49ed58d37c61868f6eb0e1da1844036b"
    sha256 cellar: :any,                 monterey:       "ddea5f9ac6cb962adb6452fc16de8be0b185628724a009ee20853c0d7ca903e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9edc05ea79a6f3de3a35514d70acefd427262d2fbbe76849cb3633cde3e96702"
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
      url "https:raw.githubusercontent.commacportsmacports-portsa859c5929c929548f5156f5cab13a2f341982e72sciencegmicfilespatch-src-Makefile.diff"
      sha256 "5b4914a05135f6c137bb5980d0c3bf8d94405f03d4e12b6ee38bd0e0e004a358"
      directory "src"
    end
  end

  def install
    # The Makefile is not safe to run in parallel.
    # Issue ref: https:github.comdtschumpgmicissues406
    ENV.deparallelize

    # Use PLUGINDIR to avoid trying to create "plug-ins" on Linux without GIMP.
    # Disable X11 by using the values from Makefile when "usrX11" doesn't exist.
    args = %W[
      PLUGINDIR=#{buildpath}plug-ins
      USR=#{prefix}
      X11_CFLAGS=-Dcimg_display=0
      X11_LIBS=-lpthread
      SOVERSION=#{version}
    ]
    system "make", "lib", "cli_shared", *args
    system "make", "install", *args, "PREFIX=#{prefix}"
    lib.install "srclibgmic.a"

    # Need gmic binary to build completions
    ENV.prepend_path "PATH", bin
    system "make", "bashcompletion", *args
    bash_completion.install "resourcesgmic_bashcompletion.sh" => "gmic"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin"gmic", test_fixtures(file)
    end
    system bin"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath"test_rodilius.jpg"
    assert_predicate testpath"test_rodilius.jpg", :exist?
  end
end