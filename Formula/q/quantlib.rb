class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://ghproxy.com/https://github.com/lballabio/QuantLib/releases/download/v1.32/QuantLib-1.32.tar.gz"
  sha256 "ef2d374ef8c320572dd4b32946da368b2dcdac41e2b87e3e9538a894efe5a6ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00e7c92ddd3c1bbd86321e9982e9c474865cd08515eeda23a8b2c0e70e4a10a1"
    sha256 cellar: :any,                 arm64_ventura:  "fae7d0ee8aa344b6c4a82256c5725eeecc69a3342a400e82e459e698ec6676c7"
    sha256 cellar: :any,                 arm64_monterey: "056d023996adadfdaa01f07ccdde6ae57f4f8cf556477fbc2470d4e0b5304bed"
    sha256 cellar: :any,                 sonoma:         "9c08362bbf4c681e04d048e92efffc0b8c8f2756ee8b966208d78d31ff8241ed"
    sha256 cellar: :any,                 ventura:        "c344d2dbe642667d0a776f562c5e700aba8f615881819f1b69d4106d477e7b07"
    sha256 cellar: :any,                 monterey:       "528266e04f4e0aa721b97cdb465a38c4945737a8e7fd8a83187d112fb02d9b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a53b71097e292036267b228d8c4c492a02e4fb41aa0818b4d5a9b5bccfc167"
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
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end