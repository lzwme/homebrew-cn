class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://ghfast.top/https://github.com/danieljprice/giza/releases/download/v2.0.1/giza-v2.0.1.tar.gz"
  sha256 "a62b0fc68712ed12ede18a7adec0d49a7784f266a11d71cb16ad4890c396986f"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f024641fa55f442d729039c358746915d5290dd27fe08003d20a25211b0dcc3"
    sha256 cellar: :any, arm64_tahoe:       "2ee493cd34cf0f7ff385d38362296793492aba1cded0ecefa4297842ffa4f416"
    sha256 cellar: :any, arm64_sequoia:     "551814298e540c253a8f488d56041a3707a1f5445335c0d81f8e6c7a4ad75a14"
    sha256 cellar: :any, arm64_linux:       "cbe657eab8d0c8f4dd71096b756d3d4204aeab48da3627d18284e07832273771"
    sha256 cellar: :any, x86_64_linux:      "df9b0e6a26071797eb3fd562fe7a343af553532597622d40066cbc01e0245b1b"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # Install test files to use during `brew test`
    rm(Dir["test/**/Makefile*"])
    prefix.install "test"
  end

  test do
    cp_r prefix/"test/C/.", testpath

    flags = %W[
      -I#{include}
      -I#{formula_opt_include("cairo")}/cairo
      -L#{lib}
      -L#{formula_opt_lib("libx11")}
      -L#{formula_opt_lib("cairo")}
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
      system ENV.cc, file, *flags
    end
  end
end