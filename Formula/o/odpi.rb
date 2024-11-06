class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https:oracle.github.ioodpi"
  url "https:github.comoracleodpiarchiverefstagsv5.4.0.tar.gz"
  sha256 "1cf9b0c9faee11514474a35d30713892ffd0a1513265c9689f48a343e7ebb99f"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de81858e088981f8356758889209fc38cd046b78a90fd8b4d0c377d1a5c5acd8"
    sha256 cellar: :any,                 arm64_sonoma:  "e630e68359496407049213673b09c555188b73c178f17b7e3c4fc2d66e2d131c"
    sha256 cellar: :any,                 arm64_ventura: "103e57a6b45e0f05a3504883e06b820402dbf711b41a1ff65e1144806d199ca9"
    sha256 cellar: :any,                 sonoma:        "2f67517af25b3942aff07d4c97e46de999e5cd6b097ea5d06c4f5976128d9985"
    sha256 cellar: :any,                 ventura:       "ee250343206980cff83b81645f67cb9069f0eaefe20b90a44f291bef769ccf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6da6de1fcbaa2183ab531e29173162f271f30ce0ce178235085e86c63b1cae"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system ".test"
  end
end