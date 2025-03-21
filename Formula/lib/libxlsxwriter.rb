class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https:libxlsxwriter.github.io"
  url "https:github.comjmcnamaralibxlsxwriterarchiverefstagsv1.2.1.tar.gz"
  sha256 "f3a43fb6b4dab2d65bcbce56088f58c94a8ae7fb5746106c069d77ef87794a24"
  license "BSD-2-Clause"
  head "https:github.comjmcnamaralibxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe1efe1c387d62c42ba87edc67bd8e13970afe6a8eaaa34f6d6e039aff822e6c"
    sha256 cellar: :any,                 arm64_sonoma:  "45e430944382db08daa5a7654eac86814e6efe0abd2c7d968a26496a745fba22"
    sha256 cellar: :any,                 arm64_ventura: "f9c7643970f84f28e3440721629a1388c58b0983e4585d41a688eaf21fea41f0"
    sha256 cellar: :any,                 sonoma:        "045187c9f34dca248ecb15c671bf788403f6d4e8277b78cb8593c15fcece78f6"
    sha256 cellar: :any,                 ventura:       "4d305cc2bf4b78783c50f36b6c91920e9e3ededeeb98a611b796064206fa2288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a92abec94b454b36bca1c9ac185f2447fe9fbeb4913cb9839d8abb6f4e8f054b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9249af47fe8cf665e057dfe679ffdcf4110184b7f31d27272456ad26d2a3cb"
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath"test.c").write <<~C
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system ".test"
    assert_path_exists testpath"myexcel.xlsx", "Failed to create xlsx file"
  end
end