class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://ghproxy.com/https://github.com/danieljprice/giza/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6bd0e96393cf6b8676592b9ae570df9aba2cd289c0de1487a2ce0f3f509596b9"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efd6e38ca14edb4a28785d5e09a0e1d9c50904131330792cdebffadf037d6e28"
    sha256 cellar: :any,                 arm64_ventura:  "6ad730962e7725b383e7333f1e6c95f5e5f2e3b3234a5582e47b7e02e86e867a"
    sha256 cellar: :any,                 arm64_monterey: "f917df9516932f3eb466e06f2d48ec3dc35a17f3eeab70ad53bf92d66496961d"
    sha256 cellar: :any,                 sonoma:         "8d497c5c6866bcffadd5d1eca2a7da7bd65e9ca9f790820fb63f8e6a494340aa"
    sha256 cellar: :any,                 ventura:        "da022f7a7999a3a00afb8e037ac9385554fedc57956c15fa544d91280b12a06d"
    sha256 cellar: :any,                 monterey:       "9f9d53f88f2b872f591a0431bbccde986535d61eb3da62d304527ea6d9a84335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157c3f949c3fa9f8455a1582d8d8596e24882910e0af4536fe7b5ef045d8da8a"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Clean up stray Makefiles in test folder
    makefiles = File.join("test", "**", "Makefile*")
    Dir.glob(makefiles).each do |file|
      rm file
    end

    prefix.install "test"
  end

  def caveats
    <<~EOS
      Test suite has been installed at:
        #{opt_prefix}/test
    EOS
  end

  test do
    test_dir = "#{prefix}/test/C"
    cp_r test_dir, testpath

    flags = %W[
      -I#{include}
      -I#{Formula["cairo"].opt_include}/cairo
      -L#{lib}
      -L#{Formula["libx11"].opt_lib}
      -L#{Formula["cairo"].opt_lib}
      -lX11
      -lcairo
      -lgiza
    ]

    %w[
      test-XOpenDisplay.c
      test-cairo-xw.c
      test-giza-xw.c
      test-rectangle.c
      test-window.c
    ].each do |file|
      system ENV.cc, testpath/"C"/file, *flags
    end
  end
end