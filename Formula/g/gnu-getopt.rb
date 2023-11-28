class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.2.tar.xz"
  sha256 "87abdfaa8e490f8be6dde976f7c80b9b5ff9f301e1b67e3899e1f05a59a1531f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "030b76f293a112b799f20edfb44f49a6674062914e945ed746384f61172702de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962335e20aba754efab14cb9bf35e956f395fe21da9f947fe75e467d5003e9a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2788388193f2e6fcffda762f3bcffc880709b2ec9eebb18e567f777b6f5fb9f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "63bdeb1a816abd155cb2d71d7e3850e0a05da44387412a377637ed7abe0bf4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "9142dcb2af8485ecc5d86875a7997f84e9fef2f5d707b15b7960ec9e690c3f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "e23d6d7f1b37ef6dfd5d8fe46c9341e3957931b447cf841cacf6203fb25ee004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de8f0bdca05a92679e4add65a6152583df1aa96268083a471c785dd7ffbfcdf"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
    doc.install "misc-utils/getopt-example.bash", "misc-utils/getopt-example.tcsh"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end