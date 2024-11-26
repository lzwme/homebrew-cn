class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https:re2c.org"
  url "https:github.comskvadrikre2creleasesdownload4.0.1re2c-4.0.1.tar.xz"
  sha256 "7c35d54fdf2c4b5981b80362d1c742aec4d011589673e02f2e9566f7e66c44af"
  license :public_domain

  bottle do
    sha256 arm64_sequoia: "02b660296dc2fed9c6d9a997367f264d0a50a4a9d21e15eeecc90238cb8af449"
    sha256 arm64_sonoma:  "8b70f0099883134ec333605e746fa6ef071e9f2d19c57dd6884f96b0ef325b73"
    sha256 arm64_ventura: "24bd685ae9895daf335900db645bbc513cc0b087676594c252eea22a52c73c31"
    sha256 sonoma:        "2a4ef603ced537c272a3eca2e3aacd76ef4059d0c48aca39bab361026d8c2303"
    sha256 ventura:       "c0019d00313d2ada49ced6bc401cd3aea4462787526afc0a004469277ea8170b"
    sha256 x86_64_linux:  "a72be4263f98de8a6b54197fc8980129832222cb1da32a22a81e28bb0426fe26"
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