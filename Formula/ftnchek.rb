class Ftnchek < Formula
  desc ""
  homepage ""
  url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1.tar.gz"
  version "3.3.1"
  sha256 "d92212dc0316e4ae711f7480d59e16095c75e19aff6e0095db2209e7d31702d4"
  license ""

  # patch :Z do
  #   url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1-varfmt.patch"
  #   sha256 "cc4372b0ab7daf6170b26e35125a65601c2204e1d0060d6aaadcffb1b2f31d38"
  # end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-submodel", "OPTIONS=-O2"
    system "make", "install"
  end

  test do
    system "#{bin}/ftnchek", "--version"
  end
end