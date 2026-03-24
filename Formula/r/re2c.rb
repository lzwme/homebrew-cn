class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://ghfast.top/https://github.com/skvadrik/re2c/releases/download/4.5/re2c-4.5.tar.xz"
  sha256 "de5431c1de9926ac6875c6d38eaedd14ba8f7fa54f3688bcca45b10006ab2ba6"
  license :public_domain

  bottle do
    sha256 arm64_tahoe:   "63e91ea99da9353d9b7bcb7418f1f6bf089e1400775f4f3a0ed492ad067ceb2e"
    sha256 arm64_sequoia: "a30d7ae47b8de7ac3b3a712bd274a021e952dc87d39fe25e783acb04c8e7c06a"
    sha256 arm64_sonoma:  "ec898c80a5a8ed831e1f1374e54e6d20b994e54c4b039600f35da9f25c561045"
    sha256 sonoma:        "ca149da9c0ec2b96d9aa12f506f358120eeebab4a9af53a415afb7aa1638080c"
    sha256 arm64_linux:   "4137c8b2e1d7c008e94992501ef6a027361d91ac22f721d9bcf83ca7c05f1f23"
    sha256 x86_64_linux:  "a7d4f7af90096849a8eb34a46189acace4cfcfbeaf7d95de0a32021a77cab587"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    C
    system bin/"re2c", "-is", testpath/"test.c"
  end
end