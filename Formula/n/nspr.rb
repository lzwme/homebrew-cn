class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.38.1/src/nspr-4.38.1.tar.gz"
  sha256 "6509fb0b0ddd42413a5ec54ede0932089e4fdcfa8be43c286300bacee72f4d0a"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4383a8a1f739dcc9ca668ad3a3f7b6537a278717c439dcd1c530c7718e629cdf"
    sha256 cellar: :any,                 arm64_sequoia: "214f55428523c2129ed799dca0c6ea5fd2697fb419778b9c848f3eb0da6dcd7e"
    sha256 cellar: :any,                 arm64_sonoma:  "2fff90cdf810eca99dc58de424757613d69eceb815175fddf67c42dec5b147b2"
    sha256 cellar: :any,                 sonoma:        "e43eb8d8e275f8f094570bcf9832029f3cda564b5ce2c7c2342b99f593daf9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9ecab6f970c6440842551369fba70f58fc8bd9511fbb9c8ca19a691446de61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b198bdbfd86f51558fd733035619adb4893114e2ccca0c77beba8fcc72ea7ca4"
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-64bit
      ]
      args << "--enable-macos-target=#{MacOS.version}" if OS.mac?
      system "./configure", *args

      if OS.mac?
        # Remove the broken (for anyone but Firefox) install_name
        inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "
      end

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system bin/"nspr-config", "--version"
  end
end