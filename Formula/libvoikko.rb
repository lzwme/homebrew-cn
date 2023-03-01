class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.1.tar.gz"
  sha256 "368240d4cfa472c2e2c43dc04b63e6464a3e6d282045848f420d0f7a6eb09a13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "d905f03033678e1985a93549e892b437690efafab797214116c0ed1bc21ca7ce"
    sha256 cellar: :any,                 arm64_monterey: "c213ed59276fe8bc58dc43d7ee5ce9c1deb4ccdb33d1971e8ae8e65700912b7a"
    sha256 cellar: :any,                 arm64_big_sur:  "0c2aaa1a03c243a94484f08b46ed8e87b3cc639dfe5667cddc1bad7af029b762"
    sha256 cellar: :any,                 ventura:        "e1b82ebb522bd46e3f1c8ccbcbcac38fc32e87c26b5d575b89be829971c319a5"
    sha256 cellar: :any,                 monterey:       "cafcdc9c54773b5fa366df849ea1cbe5ede64c7004d918e04b66a19941d7b2b1"
    sha256 cellar: :any,                 big_sur:        "0d965ae24abc08ce3a8980164f59bdc47e8a0d8c51d2ddd0dd7ca74ff6ff85f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ef478052a171da7ddc06757da03fd421ce594be30affb352e0f51321c4ea78"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.4.tar.gz"
    sha256 "320b2d4e428f6beba9d0ab0d775f8fbe150284fbbafaf3e5afaf02524cee28cc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end