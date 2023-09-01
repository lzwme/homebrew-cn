class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.6.tar.gz"
  sha256 "55993e55a30fe2da32f9533b9db2a3250affa2b32003b0c49c36eec2b2c6e007"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4910592360d8bf41b5bb32cbdecb7c08d2dcde27d0a775bee724fe02d80f9682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37492988fc86bc04b0da69b19f20b22002367ea2ce5b4ef160401c67bff1029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1e751b9dd840ce5396b0808f41069110117d3e94e3f9387257c40d5a39ec912"
    sha256 cellar: :any_skip_relocation, ventura:        "715914047c679d60888fee76bf45085cafa1ccee4bb8a06c9a8ce4544f5a6903"
    sha256 cellar: :any_skip_relocation, monterey:       "96138880e5e00f7b76a64ad2db02fc9af3e7dfb9f7dede0193b2f32a53f4a291"
    sha256 cellar: :any_skip_relocation, big_sur:        "38da3f9c843c51cb8c8025231df855f6e4e5c442c8347ca551b59af5c1f7c821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb745a1eb297c12066a2ba05af168499ab217648d9f2ca8355b70a931e5b181d"
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