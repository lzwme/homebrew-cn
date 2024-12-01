class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.10.tar.gz"
  sha256 "f4d1c8a99afcfc5414134aad5999c1505619449dbccd3d7702269b36264cfa1c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2ae2f82641c758666112a52ae120fdba03ee10afc08fd91aad38d7f111697ab3"
    sha256 arm64_sonoma:  "af0ec680b0402fe02411280567ba201d75c8df3b0078220764287ff658d57f77"
    sha256 arm64_ventura: "1921f89c2e68eedd3730a3f8b28ff4d7336b7ea4c279c5edfed72e0061ffba3d"
    sha256 sonoma:        "c1bacae412f2d6bdbd15cd45b89e91e804eae09c85945d795200ac564e4a32d1"
    sha256 ventura:       "8b153ce9c16a20e32c71d3a6be67016d7e32a9cb5deafd3038815352a1793df5"
    sha256 x86_64_linux:  "1ec918b9a07ce08eb383c81aea9398f20d6bf608cd2e6f35729a87ab3603fcfb"
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