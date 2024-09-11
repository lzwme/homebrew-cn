class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "http:www.ossp.orgpkglibuuid"
  url "https:deb.debian.orgdebianpoolmainoossp-uuidossp-uuid_1.6.2.orig.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  license "BSD-1-Clause"
  revision 2

  livecheck do
    url "https:deb.debian.orgdebianpoolmainoossp-uuid"
    regex(href=["']?ossp-uuid[._-]v?(\d+(?:\.\d+)+)\.orig\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "54fe9ac592343b06d7ce62e286cf0afd06f90be6c9aebd779102403c51cd55ea"
    sha256 cellar: :any,                 arm64_sonoma:   "54b71284924df66d47fb0544f6a20c058e4118b0b6c7e4e25938a9e5db0b19f9"
    sha256 cellar: :any,                 arm64_ventura:  "3285f1a05e275068e1c5aee7036066c23859b53f56fff5795e08cf18cd6d4d75"
    sha256 cellar: :any,                 arm64_monterey: "09aff0ba17ad31b748e80e71d1138b457798a9bff6cb101750343b47f9db06d9"
    sha256 cellar: :any,                 arm64_big_sur:  "e0ce19ff28fdcdd2f39dfc8706124f4d9b75e5fc3865ba2fc17c1de2fb9b9f29"
    sha256 cellar: :any,                 sonoma:         "f1055cbbeef1485ae007d2a71818cfb7f2a3b1e4a4cb6e7d69f7bf79796dfaf5"
    sha256 cellar: :any,                 ventura:        "be5ba7669ab915635b5d56d6bccfbaf39f6706acb66329e1ad194177eae2cb5b"
    sha256 cellar: :any,                 monterey:       "46c913bd5d404f0ea9dc7467a072ddf3d29f64dff75bfa4527476a5ed67ffd87"
    sha256 cellar: :any,                 big_sur:        "610cf9d70494965c79a4f1fc39a7b9e2854efa0e69fdd152cf54485e2d6b7958"
    sha256 cellar: :any,                 catalina:       "fd727fb38c48eda8d6bcb36be17e281b2152a54144298d39cab50ec7743e8a95"
    sha256 cellar: :any,                 mojave:         "a6852dac557e1b804a240b4f558d9b2e262adebb64424061f2ee8002a3d19476"
    sha256 cellar: :any,                 high_sierra:    "a04214b22c58bd5167778925cb9e55b98f28330bcc6c6a37929e6085ea3a0162"
    sha256 cellar: :any,                 sierra:         "3c15cd0e25e3039e0d05b94d14b714745cec3033863d5dc7a6d9ddd7cacc1c71"
    sha256 cellar: :any,                 el_capitan:     "ac4456fc1c29db7e0d565ebdd392cf827be315b52c9eb3abcd113c4c7b981f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec70863fae3001fc9281f76cef9ac231bd6dbb957c6382457a5848312ee1f1b0"
  end

  on_linux do
    conflicts_with "util-linux", because: "both install `uuid.3` file"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # upstream ticket: http:cvs.ossp.orgtktview?tn=200
    # pkg-config --cflags uuid returns the wrong directory since we override the
    # default, but uuid.pc.in does not use it
    inreplace "uuid.pc.in" do |s|
      s.gsub!(^(exec_prefix)=\$\{prefix\}$, '\1=@\1@')
      s.gsub! %r{^(includedir)=\$\{prefix\}include$}, '\1=@\1@'
      s.gsub! %r{^(libdir)=\$\{exec_prefix\}lib$}, '\1=@\1@'
    end

    system ".configure", "--prefix=#{prefix}",
                          "--includedir=#{include}ossp",
                          "--without-perl",
                          "--without-php",
                          "--without-pgsql"
    system "make"
    system "make", "install"
  end

  test do
    system bin"uuid-config", "--version"
  end
end