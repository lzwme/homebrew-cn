class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.13.tar.gz"
  sha256 "89222a0019c59418432d6a47406c4ee76517deb6fa809bb28fdbd5aca8032d27"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "376e474492e745b6d5678a6154f23cae2e51a818ffdbaca168313321d052a0b6"
    sha256 arm64_sequoia: "26bbf3986401facf83d1610e0acc87d0219f240d92f020c3b3f33381d2fc583c"
    sha256 arm64_sonoma:  "393eaec1fc3350036e21d2f4f1a3fee90a65b4fba0225685b2a38f6f6d47e90f"
    sha256 sonoma:        "ef0380b49718e189f8632c6ba134c4b8788e60ee428676f4e4a9efda532e2024"
    sha256 arm64_linux:   "69acf24b03953966f8d2fc79bf42ff82fc66a261834c0ec3bcbd5e8a5e40fcff"
    sha256 x86_64_linux:  "3190f092e922c872955e33d8c65b70b7a48e0ad4d023c83210af8d079c9321b5"
  end

  uses_from_macos "curl"
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