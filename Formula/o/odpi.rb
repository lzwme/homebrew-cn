class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://ghfast.top/https://github.com/oracle/odpi/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "9efbadd237b2670ed87cedf5bd01b485f645020373c655b69b9a2c1c82ce0d43"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05f95e0a4d38b09840028849feb22d6c93cc6973a2e728ee156f51efa949a6e9"
    sha256 cellar: :any,                 arm64_sequoia: "f040d00a9fca66140004d8e8e565d0a2bb6aa197036e5fd9d560f9ee7ef1d972"
    sha256 cellar: :any,                 arm64_sonoma:  "aa444faf14de50a3819af2a5540fd78935e6a2ec0327e7213fb85d4c1b8698ee"
    sha256 cellar: :any,                 sonoma:        "3c1463f2b8a30b378c19a25ed4264b9bcf6a3817791e2765f2e2b8e9e299ea91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ae52b460b7cd40be01e9b179b64ed3942ad1706c833b040902dc2bc804317dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d55b5e5d167b8d1f16f80e0f1c407d44e0c7b99d8b5f7ee5203d3d9bab7b24"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
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
    system "./test"
  end
end