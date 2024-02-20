class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.3.4.tar.gz"
  sha256 "f52c5c8b44afe830e0d7e177a1477621821f8aa2e5183f8a432970a17acfa0bb"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0dcbc567b4aafa81c7128b4b6f87f51d54b15a1b18913e3bf324825b2fc5e2cc"
    sha256 cellar: :any,                 arm64_ventura:  "f0212582dc56724fbe833f27fe8856eef9ae8dad3337142df5f456388ddb281c"
    sha256 cellar: :any,                 arm64_monterey: "9adecdc67a7f710bf660af95aa831a14b9db29941efc652fd2f9ef2d8b262d8f"
    sha256 cellar: :any,                 sonoma:         "5055769329393e1d8102944622ba63a46573ffcd5952bad60614777975c7a0d2"
    sha256 cellar: :any,                 ventura:        "b58baa1c6b4b3fe4ee43e3649e018a5948e00634d625d937d7eaa28f18b2bc00"
    sha256 cellar: :any,                 monterey:       "ebcde07958242de82083a06851b635d78c56465474b4ce1833a27b2a605f2e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cdbccaaf9c4a83fbc75bfd78fcc4f6e839f396dbe32c4ec55ffec7b6905444e"
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