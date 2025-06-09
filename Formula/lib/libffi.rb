class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https:sourceware.orglibffi"
  url "https:github.comlibffilibffireleasesdownloadv3.5.0libffi-3.5.0.tar.gz"
  sha256 "8c72678628a5dd8782f08ad421d5a441e42c1c5c1b33e0bc211cbfcf1f3b3978"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d70e58ccf90bf0b523bf2e5101d24be7c80af3ca16ae145dbc9853393307e1f"
    sha256 cellar: :any,                 arm64_sonoma:  "e793bde76d63862669b4ca1930932648b9bf407c7035618ad1811ac72fca4192"
    sha256 cellar: :any,                 arm64_ventura: "78d7294f94c1f792b2cbf168963082755a2a56e5b56d7020cd9beabc9828bc73"
    sha256 cellar: :any,                 sonoma:        "c484e3b8d990d47db3d27d14e24e05fffc0dc25dfb0cc415f7dae4b3d1d16e3d"
    sha256 cellar: :any,                 ventura:       "5b51f6c25e03e8cf530d654a14936d7c5498991cfddcd7d8121f18d4df0824be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae33d56cc0197e3002a58e62ac3bfc56d2d24d73e5eb5aa969afea74bfb80e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14fac203584df82854451b09c07ea269f06db5118934dbaa68e32513d95a1f4a"
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