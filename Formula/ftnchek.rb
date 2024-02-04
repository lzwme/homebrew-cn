class Ftnchek < Formula
  desc "Static analyzer for Fortran 77 programs"
  homepage "https://www.dsm.fordham.edu/~ftnchek/"
  url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1.tar.gz"
  sha256 "d92212dc0316e4ae711f7480d59e16095c75e19aff6e0095db2209e7d31702d4"

  livecheck do
    url "https://www.dsm.fordham.edu/~ftnchek/ftp-index.html"
    regex(/href=.*?ftnchek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "groff" => :build

  patch :Z do
    url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1-varfmt.patch"
    sha256 "cc4372b0ab7daf6170b26e35125a65601c2204e1d0060d6aaadcffb1b2f31d38"
  end

  def install
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-submodel", "OPTIONS=-O2",
"--mandir=#{man}", "SOELIM=/usr/local/opt/groff/bin/soelim"
    `make fortran.c || true` # bison regenerate from patched fortran.y, fails build to notify dependency changes
    system "make", "install"
  end

  test do
    system "#{bin}/ftnchek", "--version"
  end
end