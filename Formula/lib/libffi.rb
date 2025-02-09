class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https:sourceware.orglibffi"
  url "https:github.comlibffilibffireleasesdownloadv3.4.7libffi-3.4.7.tar.gz"
  sha256 "138607dee268bdecf374adf9144c00e839e38541f75f24a1fcf18b78fda48b2d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b402f2b540c097a01aca656f66c7194b15d80c6490345a0d61c6b75417c6d438"
    sha256 cellar: :any,                 arm64_sonoma:  "559ffc0a457cbaea3abbdfa85fbfc00831741bb19d88bd6c14dce468f8994fce"
    sha256 cellar: :any,                 arm64_ventura: "423220c0d91181fd0bea9739d023402deb68f6af4dafba772de1153cc9b960f6"
    sha256 cellar: :any,                 sonoma:        "98bac85bf39a8b7d0f9bafef282793a8b5ab85bb17e502b27c0bf5f7d5cf8a1b"
    sha256 cellar: :any,                 ventura:       "8c6ddb10ef9d24f35611f9aca29eb290baf1f89ce8835a6fa0a19caac2531020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea07199765ba473ae2b693aea558e8865a60358ccc1ae209dd8bbd94f219048b"
  end

  head do
    url "https:github.comlibffilibffi.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"closure.c").write <<~C
      #include <stdio.h>
      #include <ffi.h>

      * Acts like puts with the file given at time of enclosure. *
      void puts_binding(ffi_cif *cif, void *ret, void** args, void *stream)
      {
        *(unsigned int *)ret = fputs(*(char **)args[0], (FILE *)stream);
      }

      int main()
      {
        ffi_cif cif;
        ffi_type *args[1];
        ffi_closure *closure;

        int (*bound_puts)(char *);
        int rc;

        * Allocate closure and bound_puts *
        closure = ffi_closure_alloc(sizeof(ffi_closure), &bound_puts);

        if (closure)
          {
            * Initialize the argument info vectors *
            args[0] = &ffi_type_pointer;

            * Initialize the cif *
            if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 1,
                             &ffi_type_uint, args) == FFI_OK)
              {
                * Initialize the closure, setting stream to stdout *
                if (ffi_prep_closure_loc(closure, &cif, puts_binding,
                                         stdout, bound_puts) == FFI_OK)
                  {
                    rc = bound_puts("Hello World!");
                    * rc now holds the result of the call to fputs *
                  }
              }
          }

        * Deallocate both closure, and bound_puts *
        ffi_closure_free(closure);

        return 0;
      }
    C

    flags = ["-L#{lib}", "-lffi", "-I#{include}"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system ".closure"
  end
end