class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https:aria2.github.io"
  url "https:github.comaria2aria2releasesdownloadrelease-1.37.0aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "89117256b91a5a87d4e31fb4054f7a0b45681a97627547b4db7498930486ff05"
    sha256 arm64_ventura:  "fd06b5b187243559c5f286767ab8f7f7d5f16d361bbd3ff9faf0909643920849"
    sha256 arm64_monterey: "515cf8d197ec78753fa6b7462f775a3e625340e04f02207ae6dd1b6135afecdd"
    sha256 sonoma:         "7ad8b56e2edf9df28458b88cc88faec5e7ada3bd9b5652420aa6168325a10260"
    sha256 ventura:        "2821ec44b09994465d3bb8f8e4da6af8d2dd70cbdbf92f3b75d18ba65064e681"
    sha256 monterey:       "41ce19b788f94a35025e306afa0f90a85164243d18f7350340cf75b9edf18b6c"
    sha256 x86_64_linux:   "e459fd063b80457e1d8ead88e3168effb13a80974e4d5e2fcd1bd2a11aa1cb00"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]
    if OS.mac?
      args << "--with-appletls"
      args << "--without-openssl"
    else
      args << "--without-appletls"
      args << "--with-openssl"
    end

    system ".configure", *args
    system "make", "install"

    bash_completion.install "docbash_completionaria2c"
  end

  test do
    system "#{bin}aria2c", "https:brew.sh"
    assert_predicate testpath"index.html", :exist?, "Failed to create index.html!"
  end
end