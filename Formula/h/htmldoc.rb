class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https:www.msweet.orghtmldoc"
  url "https:github.commichaelrsweethtmldocarchiverefstagsv1.9.19.tar.gz"
  sha256 "5975a5b906de8506c14aedbbf4b954886b4972637d1f0609c6d2546933f3038d"
  license "GPL-2.0-only"
  head "https:github.commichaelrsweethtmldoc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "7d9d968e4f563c7c6f1b0695340f0236f4b8014a102094988e14942119bbebfd"
    sha256 arm64_sonoma:  "f8b178aefc212dec9c57d065b1f9cb754f3ef3aa40b29f067496d7b5f9d17953"
    sha256 arm64_ventura: "7f83f8df62f8bf32baf2831a87d2e5050f776034022fc3aae00b2fa15ef462ed"
    sha256 sonoma:        "7f0fd22d7423ac61f497f0937bb95eac75db859886473a51dac68c955fbfb3c9"
    sha256 ventura:       "b2fe28733a17755ce87c5006ff2b9ba347cdd4fcb358792241cdea2f77023ab1"
    sha256 x86_64_linux:  "7a3c3054f5628a3ce636939808c5db98daa187a4b2bc9a2ca6b1c040b48b3c49"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system ".configure", "--mandir=#{man}",
                          "--without-gui",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin"htmldoc", "--version"
  end
end