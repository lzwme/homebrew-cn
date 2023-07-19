class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://ghproxy.com/https://github.com/lballabio/QuantLib/releases/download/v1.31/QuantLib-1.31.tar.gz"
  sha256 "ddf630abce0f755eb9e990c437afc1927718202e2bbfeee8ce57612ce559b64b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89c8e375f631063e6061e8ec4eca5c29b83199523e05b6adc68f2726a93fd1b3"
    sha256 cellar: :any,                 arm64_monterey: "98485f72ef9634272286124c8c4953c3aa693107cb757231247d945b4e6b6051"
    sha256 cellar: :any,                 arm64_big_sur:  "bceb803e290a6169ad38ab837bf45443a57cc0a2f1e94298ead6009b79acc8c0"
    sha256 cellar: :any,                 ventura:        "b9f391ace54b6934f62271beca5bb798f9fb5de1ab66f68b9c668a73c2f17e63"
    sha256 cellar: :any,                 monterey:       "f93dc6d35df8cb2e2f650a43bea92d917cb1322464a563661c92b383c6a67361"
    sha256 cellar: :any,                 big_sur:        "2bc72f50b20e941c6d33d4ae1c74f6c4c419910b4a6bea636137d0aab6d4f8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2b49ace6b8b24e7a4db659a73444ecc1576df2c85eef4691e45e0627f63f61"
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