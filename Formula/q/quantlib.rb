class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://ghfast.top/https://github.com/lballabio/QuantLib/releases/download/v1.42/QuantLib-1.42.tar.gz"
  sha256 "60319f947b4867194d5b1c5ef7ccbdd11b86fac8670d3f23fbe3057e78447728"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab7fd666a544adff5760f1a1d7076459024ed03c3bf364c37882ce9fed34f6c4"
    sha256 cellar: :any,                 arm64_sequoia: "59f423c669e87dce890c119a1147a6b49488d5dd338be2bebfe81e85ff62b3ca"
    sha256 cellar: :any,                 arm64_sonoma:  "31a5892b3d3a17ea1f9605a12a3392bfe561404c3e853e779532205e84b1b45b"
    sha256 cellar: :any,                 sonoma:        "12b4da3e8b6818bb6d1b07850c66a4945efe4fa4189140822ae12d19c30f489b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97088d697fabde3da912e5a1221e9f388134b2eec7844a26567607e2ceb10f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad91def812da67765550bf7a0a0d4e2b316f08d80a9e4ffabdff27e8358aea2b"
  end

  head do
    url "https://github.com/lballabio/quantlib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end