class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https:wiki.debian.orgApt"
  # Using git tarball as Debian does not retain old versions at deb.debian.org
  url "https:salsa.debian.orgapt-teamapt-archive3.1.0apt-3.1.0.tar.bz2"
  sha256 "69e6117b192491c6ffbdd74c60dbb37a9afa63daeba043ff219bad4d92182a07"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:deb.debian.orgdebianpoolmainaapt"
    regex(href=.*?apt[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_linux:  "63cbae9a9b707ffb1d282a381b1a3631dcb0b3c4e1de1900ea1e8b7dd5b92503"
    sha256 x86_64_linux: "826db8a183201f16a07ec73d4feb25cabc39c85b5763e1ce12bb53c46ec6eddf"
  end

  keg_only "not linked to prevent conflicts with system apt"

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "libxslt" => :build
  depends_on "llvm" => :build if DevelopmentTools.gcc_version("usrbingcc") < 13
  depends_on "po4a" => :build
  depends_on "w3m" => :build

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "bzip2"
  depends_on "dpkg"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "sequoia-sqv"
  depends_on "systemd"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  fails_with :gcc do
    version "12"
    cause "error: static assertion failed: Cannot construct map for key type"
  end

  resource "triehash" do
    url "https:github.comjulian-klodetriehasharchiverefstagsv0.3.tar.gz"
    sha256 "289a0966c02c2008cd263d3913a8e3c84c97b8ded3e08373d63a382c71d2199c"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    ENV.llvm_clang if DevelopmentTools.gcc_version("usrbingcc") < 13
    ENV.prepend_path "PATH", buildpath"bin"

    resource("triehash").stage do
      (buildpath"bin").install "triehash.pl" => "triehash"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DDPKG_DATADIR=#{Formula["dpkg"].opt_libexec}sharedpkg",
                    "-DDOCBOOK_XSL=#{Formula["docbook-xsl"].opt_prefix}docbook-xsl",
                    "-DBERKELEY_INCLUDE_DIRS=#{Formula["berkeley-db@5"].opt_include}",
                    "-DWITH_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgetc"apt.conf.d").mkpath
  end

  test do
    assert_match "apt does not have a stable CLI interface. Use with caution in scripts",
                 shell_output("#{bin}apt list 2>&1")
  end
end