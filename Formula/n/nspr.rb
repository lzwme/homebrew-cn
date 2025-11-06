class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.38/src/nspr-4.38.tar.gz"
  sha256 "72ee73ffcc6ef5e706965f855ecf470ec3986c3e188e12a8a8006e76f6b31a6f"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9933c6a00cc24a7248d6e89e27215faeeaf78da380cc71777b8ec0f9db9705ba"
    sha256 cellar: :any,                 arm64_sequoia: "c7fed9556857b3a4abdffaf307a37e10e65b377577751265ee0a09cdd947d7db"
    sha256 cellar: :any,                 arm64_sonoma:  "72a6740bcb915e8ec45f6936ccc7a1852ccef979c8e2e055dd98ca9588113f55"
    sha256 cellar: :any,                 sonoma:        "fdcf51c4ca388fbea11157cb9c2d003eb3216f7984f77537e48e6c16be5739e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90411df579739274dbe87740ac56419d899a6aa92f8ae993c66056f27f84bbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b82182a835b57084e18aeace9576d36ad73f6d37e637b14fc45174f28511acb"
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