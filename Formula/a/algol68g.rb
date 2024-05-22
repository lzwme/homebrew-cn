class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.2.tar.gz"
  sha256 "804b020e173c72a0a0121e53c3b56efbab08a32704a6d800ecc7b6ee8bc2aa33"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c7bdadabd0003746be7c8495cec77f327f78531a52d71f704dd7cf01f2e7eb97"
    sha256 arm64_ventura:  "029512f901fe3dc3885c8dc9e08881b04c75d6cf6dfa0b647be3e0f2b901157f"
    sha256 arm64_monterey: "2186631960c3c23fb041fcc4da161932f17402059403316dfe7ac37621265632"
    sha256 sonoma:         "b8aab101cd2f686825c1bd5b6a2edb863e04b0f26f4aa6bc67b4861fcb9f76e4"
    sha256 ventura:        "dd7d252e6c9645ccbb7c973b8d000faf2270ca246cb4fcc3e44dc2a241f5da15"
    sha256 monterey:       "70cb966283dbdeadc335872b7bf11cc13db927629102a1dde800a865d1e5ac02"
    sha256 x86_64_linux:   "9ad3234eb6e69d87de982573d9eb814c853015f6bcb4c84ca8b4a86521cc1e56"
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