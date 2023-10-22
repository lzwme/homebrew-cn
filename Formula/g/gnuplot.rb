class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.10/gnuplot-5.4.10.tar.gz"
  sha256 "975d8c1cc2c41c7cedc4e323aff035d977feb9a97f0296dd2a8a66d197a5b27c"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "04ca8099532e677c80a2e0dd65d2012941e5c3b53c3897f41b47c236c89129ca"
    sha256 arm64_ventura:  "e25c05265f8d139a0b01a06bd1ea71557f170625743cd8a497496cd362817acf"
    sha256 arm64_monterey: "3e2407a40a5424390354534912ca8d885e39cb3414dcc57f954d0911e1591715"
    sha256 sonoma:         "6d4854f0ea469038e2bd64c99a4e04d94d1feb4672f9a67e89cad3a2f19962e9"
    sha256 ventura:        "92b7ec37f33014601c24d3b9edc9f1c60569edf340aa10897a1d737345136b36"
    sha256 monterey:       "c5eb8a8ebc3a532d0c42e989344eb86084d365672f5e596d7eda9e79b0075c0d"
    sha256 x86_64_linux:   "c81d616534185dfc47a258325132b0d8f15dc4fff2661a7e1bf1468376aeccba"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

  fails_with gcc: "5"

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
      LRELEASE=#{Formula["qt"].bin}/lrelease
      MOC=#{Formula["qt"].pkgshare}/libexec/moc
      RCC=#{Formula["qt"].pkgshare}/libexec/rcc
      UIC=#{Formula["qt"].pkgshare}/libexec/uic
    ]

    if OS.mac?
      # pkg-config files are not shipped on macOS, making our job harder
      # https://bugreports.qt.io/browse/QTBUG-86080
      # Hopefully in the future gnuplot can autodetect this information
      # https://sourceforge.net/p/gnuplot/feature-requests/560/
      qtcflags = []
      qtlibs = %W[-F#{Formula["qt"].opt_prefix}/Frameworks]
      %w[Core Gui Network Svg PrintSupport Widgets Core5Compat].each do |m|
        qtcflags << "-I#{Formula["qt"].opt_include}/Qt#{m}"
        qtlibs << "-framework Qt#{m}"
      end

      args += %W[
        QT_CFLAGS=#{qtcflags.join(" ")}
        QT_LIBS=#{qtlibs.join(" ")}
      ]
    end

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end