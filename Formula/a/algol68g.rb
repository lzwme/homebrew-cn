class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.4.tar.gz"
  sha256 "a12ae873df4bd445b562e6446167122e46820d5fba9dce045cb90a1e5967a1a3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0dfd435a039116f87bda5f972f0d6d4d8045a4bd44b375b34d90d89492759d9e"
    sha256 arm64_sequoia: "7fcaa4ba863f7ec5e10a5d8628603cbe2a2e7ebc52a531273198bb86cf3e6e7b"
    sha256 arm64_sonoma:  "3140406b51c78466c706146c020289775669c4b82f3d2778744c112a3dd94932"
    sha256 sonoma:        "e851dd4af5934f7d542b1b0529e98822c6ddb92a9e9c6d0da99b9322379d28fd"
    sha256 arm64_linux:   "a0e794ef54113013a142b53614b2fdede5ead93f9e2a000173b0523f999c3e3e"
    sha256 x86_64_linux:  "1cadce599f8cc7e58604dcf8bad939e84bfbae0829e5f4db8fe6d3d8eb6a27d4"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end