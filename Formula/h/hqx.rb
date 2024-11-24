class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https:github.comgrom358hqx"
  url "https:github.comgrom358hqx.git",
      tag:      "v1.2",
      revision: "124c9399fa136fb0f743417ca27dfa2ca2860c2d"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "d0546464bc8981a17a079d2e9264ae9bbca9cbd7db380b0c2d8c76addf18f4e5"
    sha256 cellar: :any,                 arm64_sonoma:   "1d690216c9ec6dedb23e318b8d83da3687dcedf9f1a533ad59e58e6fcf6be39b"
    sha256 cellar: :any,                 arm64_ventura:  "83b6c8f9ae3cfcf01fd4745bf1170829206069830a119324cf382c7a258ea66b"
    sha256 cellar: :any,                 arm64_monterey: "09abea6af7106f8bdcf0e58e7b17cd91e1c22074139596a2c4f23afdbf9c9a07"
    sha256 cellar: :any,                 arm64_big_sur:  "d782e36758fe3e2a3b354a3c9e021078230934c2bbc2bd4f7043cf7ad570f542"
    sha256 cellar: :any,                 sonoma:         "4f96059b9bb168ee276f6cd0ea67f3f21240c03682dfb57ec3b672258100ef57"
    sha256 cellar: :any,                 ventura:        "dcf39c5df3a0caa4b58e68cf62d77fb1f5c75fdfb1c2d1cd31dab8ad263d69f5"
    sha256 cellar: :any,                 monterey:       "3d8f69b255851ecfcefd4ddaf2011eb70a2a038868001194fcff7f87c777c891"
    sha256 cellar: :any,                 big_sur:        "8eccb719985ba896880e42efd7266c24ee920c3952441ac90f8fb327c875b1c0"
    sha256 cellar: :any,                 catalina:       "d59524a43357e8590e15fbb039891261b2d3c6c33bf073fece8bfa568c3b9710"
    sha256 cellar: :any,                 mojave:         "3714c62ed8c552ddf8242b87845c5d35d17341d44ffea5cc3feceaa2e4c7e960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10418410cbd8fb6be975c40e233a41031491a307ef05a021f5be55e379063cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "php" => :test
  depends_on "devil"

  def install
    ENV.deparallelize
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"hqx", test_fixtures("test.jpg"), "out.jpg"
    output = pipe_output("php -r \"print_r(getimagesize('file:#{testpath}out.jpg'));\"")
    assert_equal <<~EOS, output
      Array
      (
          [0] => 4
          [1] => 4
          [2] => 2
          [3] => width="4" height="4"
          [bits] => 8
          [channels] => 3
          [mime] => imagejpeg
      )
    EOS
  end
end