class Icu4cAT76 < Formula
  desc "CC++ and Java libraries for Unicode and globalization"
  homepage "https:icu.unicode.orghome"
  url "https:github.comunicode-orgicureleasesdownloadrelease-76-1icu4c-76_1-src.tgz"
  version "76.1"
  sha256 "dfacb46bfe4747410472ce3e1144bf28a102feeaa4e3875bac9b4c6cf30f4f3e"
  license "ICU"
  revision 2

  livecheck do
    url :stable
    regex(^release[._-]v?(76(?:[.-]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36740927f8bdb436e6a4fa4066ac13d32edaaf4125ba3f20ca12e18d7eecbd6f"
    sha256 cellar: :any,                 arm64_sonoma:  "75dc3baf41567d78c356904dd11c66d4a052dc81fc8f06b574d169a10f373b94"
    sha256 cellar: :any,                 arm64_ventura: "07be73f27660fabda108d0ac346f862763a871b6ac1b257b1e84ab234a6ca2b4"
    sha256 cellar: :any,                 sonoma:        "15465a73773821af7d4b86219a496664b677b426794a43d1231ee57f86241ee8"
    sha256 cellar: :any,                 ventura:       "d7186e6b5e4a11a0614ecc251633825ade3a548f8bdedce230dc0d2982c3ff78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96de6e1689d33123805108c40a8411dfa341b1cfc963af19ecd8f1ffe63b30b0"
  end

  keg_only :versioned_formula

  def install
    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system ".configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "usrsharedictwords"
      system bin"gendict", "--uchars", "usrsharedictwords", "dict"
    else
      (testpath"hello").write "hello\nworld\n"
      system bin"gendict", "--uchars", "hello", "dict"
    end
  end
end