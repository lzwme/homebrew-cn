class Bc < Formula
  desc "Arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftp.gnu.org/gnu/bc/bc-1.08.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/bc/bc-1.08.0.tar.gz"
  sha256 "7db49996cbe16d7602936fef586e69e492c3df65765c0a891841025a1ad741ef"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcd3785211342a0f70f9f4ae2c0a2386d9b97770112dd91e1b0154fe969b3da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28c1c1070265e540f8e4ed3654543215ade6f873d57b2c88bf48bcf29294973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ac31554ea63cb26e2b3b09c00841b6c6e19d10132d79b274a3c3dc1cc75f478"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd63d528a58631598539406b115adcd020d01d4a8a355dd61a709ef73b2ca9d8"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e61633d903d925fc56fae56d4c03d99e6fe3cef558c1017ad61e604bb64378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f97276c2ec8b2883694ffa4f062c004ed07bf2966ca9847a2e8a3e365d6e8c8"
  end

  keg_only :provided_by_macos # before Ventura

  uses_from_macos "bison" => :build
  uses_from_macos "ed" => :build
  uses_from_macos "flex"
  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "bc-gh", because: "both install `bc` and `dc` binaries"

  # build fix to fix `No rule to make target `-ledit', needed by `dc'.  Stop.`
  patch :DATA

  def install
    # prevent user BC_ENV_ARGS from interfering with or influencing the
    # bootstrap phase of the build, particularly
    # BC_ENV_ARGS="--mathlib=./my_custom_stuff.b"
    ENV.delete("BC_ENV_ARGS")

    system "./configure", "--disable-silent-rules",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--with-libedit",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bc", "--version"
    assert_match "2", pipe_output(bin/"bc", "1+1\n", 0)
  end
end

__END__
diff --git a/dc/Makefile.am b/dc/Makefile.am
index 6a7fe7f..61e79ca 100644
--- a/dc/Makefile.am
+++ b/dc/Makefile.am
@@ -11,4 +11,3 @@ MAINTAINERCLEANFILES = Makefile.in

 AM_CFLAGS = @CFLAGS@

-$(PROGRAMS): $(LDADD)
diff --git a/dc/Makefile.in b/dc/Makefile.in
index b20e82f..8e7ed75 100644
--- a/dc/Makefile.in
+++ b/dc/Makefile.in
@@ -610,8 +610,6 @@ uninstall-am: uninstall-binPROGRAMS
 .PRECIOUS: Makefile


-$(PROGRAMS): $(LDADD)
-
 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
 .NOEXPORT: