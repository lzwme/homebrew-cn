class Giza < Formula
  desc "Scientific plotting library for CFortran built on cairo"
  homepage "https:danieljprice.github.iogiza"
  url "https:github.comdanieljpricegizaarchiverefstagsv1.4.3.tar.gz"
  sha256 "6023bd7f9f608fad4cc9e30ad2d00570eee7007411d4750191d6c17bd97f5a02"
  license "LGPL-3.0-only"
  head "https:github.comdanieljpricegiza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afe823e036e4028dcb11f000d68d7e84a7c5d6681423eb81eff25175a29d0c77"
    sha256 cellar: :any,                 arm64_sonoma:  "8d9b1ef22e40319ec7961587b35037bd672a2416a250b990fdc0419a2f514874"
    sha256 cellar: :any,                 arm64_ventura: "89a9fc54fea042b4d20a23ecb7fb2b6debe5d22aa1fe0bb27c1bb27233183f9d"
    sha256 cellar: :any,                 sonoma:        "d886629a3080ed36b828b5f1f4462cf0d6b9ff29d524f1a9e8356d37e3dc0151"
    sha256 cellar: :any,                 ventura:       "6e95e55c707393413697296d5012b02ea84faead3c2e725d6037868494b52fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449a4ea38c5ae28d61449ab6c87f2c4071b9331ddbcd4868572437611781a9db"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
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
        #{opt_prefix}test
    EOS
  end

  test do
    test_dir = "#{prefix}testC"
    cp_r test_dir, testpath

    flags = %W[
      -I#{include}
      -I#{Formula["cairo"].opt_include}cairo
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
      system ENV.cc, testpath"C"file, *flags
    end
  end
end