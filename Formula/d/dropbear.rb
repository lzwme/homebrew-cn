class Dropbear < Formula
  desc "Small SSH serverclient for POSIX-based system"
  homepage "https:matt.ucc.asn.audropbeardropbear.html"
  url "https:matt.ucc.asn.audropbearreleasesdropbear-2024.84.tar.bz2"
  sha256 "16e22b66b333d6b7e504c43679d04ed6ca30f2838db40a21f935c850dfc01009"
  license "MIT"

  livecheck do
    url :homepage
    regex(href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52d5fdddb3d48948c30ac5ac07fce0aebd0c646f73aa25f9ada33f0135c980c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de14b9b8ee2fe0748967c8abfab65d2130bf073fc1d9b6df336a0b57d462e5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6a236425fffe2f0e11b8915f520a2993202569fd2a24956009b1fc15a38910"
    sha256 cellar: :any_skip_relocation, sonoma:         "495fa9bea3f83194bffa157f977ba5f4240b71e381b4e7680c406f75c0ca4b98"
    sha256 cellar: :any_skip_relocation, ventura:        "6633c00f0960b56bd242188101ccfc90a257b4d86f64e711fe60e58a3dd2ce05"
    sha256 cellar: :any_skip_relocation, monterey:       "52111d59988e02fc002009ce5b98c59c167a75960d17d03073084a1d14348b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a10a9d4c06373f813601e4a7cfb9ca33378adcf5f36e66d541d4f934ccddf44"
  end

  head do
    url "https:github.commkjdropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system ".configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath"testec521"
    system "#{bin}dbclient", "-h"
    system "#{bin}dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end