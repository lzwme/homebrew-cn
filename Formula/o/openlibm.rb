class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https:openlibm.org"
  url "https:github.comJuliaMathopenlibmarchiverefstagsv0.8.4.tar.gz"
  sha256 "c0bac12a6596f2315341790a7f386f9162a5b1f98db9ec40d883fce64e231942"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0776af36be347c67b076c89d8994d4128b171b02ae9545c927290977b3eabff8"
    sha256 cellar: :any,                 arm64_sonoma:  "67467f62329ea8576d2f9e90e0a44ba0f4d799e320da08ffedbda74e779734bc"
    sha256 cellar: :any,                 arm64_ventura: "62405a2aba7a17867d89fc1eae57dbedb92699a2bc0beb8b7b027e918d1aa7b1"
    sha256 cellar: :any,                 sonoma:        "0c9c45627da4d113b460724dd1ba35d03a0b51839dadc8c4cc38564676c58907"
    sha256 cellar: :any,                 ventura:       "09a55cdae46e590f8247b5edc222bb76ba3660de90278d6a606cde852adc52be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1738a7fb1d76e4feea40e0d451bb0deb4e2a2e404dd0a9e8f2cb5b1f3428929c"
  end

  def install
    lib.mkpath
    (lib"pkgconfig").mkpath
    (include"openlibm").mkpath

    system "make", "install", "prefix=#{prefix}"

    lib.install Dir["lib*"].reject { |f| File.directory? f }
    (lib"pkgconfig").install Dir["libpkgconfig*"]
    (include"openlibm").install Dir["includeopenlibm*"]
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include "openlibm.h"
      int main (void) {
        printf("%.1f", cos(acos(0.0)));
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}openlibm",
           "-o", "test"
    assert_equal "0.0", shell_output(".test")
  end
end