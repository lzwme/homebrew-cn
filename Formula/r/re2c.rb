class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https:re2c.org"
  url "https:github.comskvadrikre2creleasesdownload4.0re2c-4.0.tar.xz"
  sha256 "6281c6bf52e684d5727ac293667c8031a4aa9010636512da5aee45f19987c1ee"
  license :public_domain

  bottle do
    sha256 arm64_sequoia: "c6e925964ade3f831e260c9ef8f3977ae423b5bca9aa452d049d8b5dbb20893a"
    sha256 arm64_sonoma:  "c4e885a78f87ccb246382a0466c2f56b30aa110dee208d3898167b4ad128bcda"
    sha256 arm64_ventura: "0b4ccdcea45364ec6d0c40c7e1cdbdcb6a7562df59958d862d4e55876786d45e"
    sha256 sonoma:        "b4ad39f50fb5d8b9a2e60b52d40cc62f9101aa040f6dc80c4cba9be74a832217"
    sha256 ventura:       "fa8ed1d391ca9e435b4cf68d50665ba171266ae29304f9e247e6a23d47ee0a5f"
    sha256 x86_64_linux:  "555af5849bd65de88ec034c005b4d0e85e13fb768df4382c9d722d8a2c86e550"
  end

  uses_from_macos "python" => :build

  def install
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              *!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              *
          }
      }
    C
    system bin"re2c", "-is", testpath"test.c"
  end
end