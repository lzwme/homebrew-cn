class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https:github.comadah1972libunibreak"
  url "https:github.comadah1972libunibreakreleasesdownloadlibunibreak_6_0libunibreak-6.0.tar.gz"
  sha256 "f189daa18ead6312c5db6ed3d0c76799135910ed6c06637c7eea20a7e5e7cc7f"
  license "Zlib"

  livecheck do
    url :stable
    regex(v?(\d+(?:[_-]\d+)+)$i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95340a8ce8dbed734050241695e3a2d0f3ea65f9e925e996ba17dc1975e98530"
    sha256 cellar: :any,                 arm64_ventura:  "e768ed6928fe22d39cf7b14080bc2ff103d04712aa2b0125b09d4a0a93bb185e"
    sha256 cellar: :any,                 arm64_monterey: "e2b5ed031a0a55518b11d6650ba1677be0b90fc8b2df8999e2b77d6aa7193099"
    sha256 cellar: :any,                 sonoma:         "148c48b957bb99c3c201db782ec6b4bfaa718eeef3e20b99ed7702504258f999"
    sha256 cellar: :any,                 ventura:        "a5f4cf2c14e3052df8c5d8ab8ce7e370d4390b16b9b82515e1bdde4606ad24ba"
    sha256 cellar: :any,                 monterey:       "a4975936199847a98806912b15546e86403b6c792a66fb5ca9fdb454ab861d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8e6b4bf0cf7bf07030458920bc48274b8fef96a67f022f2a03947e6276f162"
  end

  def install
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <unibreakbase.h>
      #include <linebreak.h>
      #include <assert.h>
      #include <stdlib.h>
      #include <string.h>
      int main() {
        static const utf8_t input[] = "test\\nstring \xF0\x9F\x98\x8A test";
        char output[sizeof(input) - 1];
        static const char expected[] = {
          2, 2, 2, 2, 0,
          2, 2, 2, 2, 2, 2, 1,
          3, 3, 3, 2, 1,
          2, 2, 2, 4
        };

        assert(sizeof(output) == sizeof(expected));

        init_linebreak();
        set_linebreaks_utf8(input, sizeof(output), NULL, output);

        return memcmp(output, expected, sizeof(output)) != 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lunibreak"
    system ".test"
  end
end