class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.100.tar.xz"
  sha256 "11b1521a7b9246842ee2e9bd9d239341a642253b57d0d7011d500d11e9471a2f"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1ecab252876ad0c5fa8399bdb9baf6e5ee1242597d6ce156f834f664ea50bf5a"
    sha256 arm64_sonoma:  "e877110a847c362af018f6f78271062523814535f7d81da823e3c6f33500c049"
    sha256 arm64_ventura: "77f4b9071d00e5a97a6a471b35c2b3f4e51299835f6f60652fdae1baf4b449d7"
    sha256 sonoma:        "cf55f4b5af9201ebade7b169f509f3e49cfdc3eabd5532aab02cde037b132b75"
    sha256 ventura:       "567db783093aeb8f3cd16687dd726dd8933ba4dd40cf92ce609bfc5b4ae93052"
    sha256 x86_64_linux:  "dd8949890c0eda690b192806c76b955fe6a484e2ccc97a2a088fbb1f5da4365f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end