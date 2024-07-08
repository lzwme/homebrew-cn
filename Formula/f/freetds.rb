class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.19.tar.bz2", using: :homebrew_curl
  sha256 "90aeb983c34b313f9dc494da005be224d4e84bd119feb2a5b1ecb73a94289f95"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "744b32601a0d8b4f00e2fb41c1e1db6d861eafca5581754e046eadc3ef70f0b7"
    sha256 arm64_ventura:  "3e3fb9cbe29b114d0a3d5acd07d9c63c49c3d0dc184fc8f562e1cdeaeb56066b"
    sha256 arm64_monterey: "b752ff6b59104e86bae2af37c367887b9022026d7411135f57aca5b4d844996e"
    sha256 sonoma:         "a24786717aa1e0c2d8a5d060b2c8da1aac882730e0d87b0fdb32a8c59df414bb"
    sha256 ventura:        "2d0a3434822cc9178851a63361d358a485fedd45429a6d6d3828f56bd207a95d"
    sha256 monterey:       "da405414a1a1579fced6233c9b2f7469386e1cbd4492f1db5722e7c78b50da5f"
    sha256 x86_64_linux:   "e6b6b7a3c6a0d664aa47df506398f943dd7dcacddbdd0c264d04224418fcb220"
  end

  head do
    url "https:github.comFreeTDSfreetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system ".autogen.sh", *args
    else
      system ".configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}tsql", "-C"
  end
end