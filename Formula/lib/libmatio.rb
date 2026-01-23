class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.30/matio-1.5.30.tar.gz"
  sha256 "8bd3b9477042ecc00dd71c04762fa58468e14cccc32fd8c6826c2da1e8bc3107"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4714998f82694d1ff038f9f988e2defcffe7d357b149101d02707444234fb54f"
    sha256 cellar: :any,                 arm64_sequoia: "c01d728dd7dcf70725970e28fc3f2b9ad4f3487fd674d9d383ca084e9fc17148"
    sha256 cellar: :any,                 arm64_sonoma:  "b356feaa4538cb11be3d90bbb1ea6b4067fdd05660961af4235a840572696a0f"
    sha256 cellar: :any,                 sonoma:        "5cbc6aa0d449de22ffe87a5a284df337470fc862fa9e5479f68de25c09556c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b1d7df74db4ceefd07bcfb1881e0870b6bc29613d11731568a298747fa7da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac75cede8b26686a16ac02c0f5e0c50fa9331ee0739f9f53dd6de88074afb1eb"
  end

  depends_on "pkgconf" => :test
  depends_on "hdf5"
  uses_from_macos "zlib"

  # fix pkg-config linkage for hdf5 and zlib
  patch :DATA

  def install
    args = %W[
      --enable-extended-sparse=yes
      --enable-mat73=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" unless OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-test_mat_file" do
      url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
      sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
    end

    testpath.install resource("homebrew-test_mat_file")
    (testpath/"mat.c").write <<~C
      #include <stdlib.h>
      #include <matio.h>

      size_t dims[2] = {5, 5};
      double data[25] = {0.0, };
      mat_t *mat;
      matvar_t *matvar;

      int main(int argc, char **argv) {
        if (!(mat = Mat_Open(argv[1], MAT_ACC_RDONLY)))
          abort();
        Mat_Close(mat);

        mat = Mat_CreateVer("test_writenan.mat", NULL, MAT_FT_DEFAULT);
        if (mat) {
          matvar = Mat_VarCreate("foo", MAT_C_DOUBLE, MAT_T_DOUBLE, 2,
                                 dims, data, MAT_F_DONT_COPY_DATA);
          Mat_VarWrite(mat, matvar, MAT_COMPRESSION_NONE);
          Mat_VarFree(matvar);
          Mat_Close(mat);
        } else {
          abort();
        }
        mat = Mat_CreateVer("foo", NULL, MAT_FT_MAT73);
        return EXIT_SUCCESS;
      }
    C
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    system "./mat", "poc_data.mat.sfx"

    refute_includes "-I/usr/include", shell_output("pkgconf --cflags matio")
  end
end

__END__
diff --git a/matio.pc.in b/matio.pc.in
index 96d9402..139f11e 100644
--- a/matio.pc.in
+++ b/matio.pc.in
@@ -6,6 +6,5 @@ includedir=@includedir@
 Name: MATIO
 Description: MATIO Library
 Version: @VERSION@
-Libs: -L${libdir} -lmatio
-Cflags: -I${includedir}
-Requires.private: @HDF5_REQUIRES_PRIVATE@ @ZLIB_REQUIRES_PRIVATE@
+Libs: -L${libdir} -lmatio @HDF5_LIBS@ @ZLIB_LIBS@
+Cflags: -I${includedir} @HDF5_CFLAGS@ @ZLIB_CFLAGS@