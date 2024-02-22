class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https:people.redhat.comsgrubblibcap-ng"
  url "https:people.redhat.comsgrubblibcap-nglibcap-ng-0.8.4.tar.gz"
  sha256 "68581d3b38e7553cb6f6ddf7813b1fc99e52856f21421f7b477ce5abd2605a8a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c95eb278def830071146f6a7f5e9cdd9f03caf71646604b5a4013a3750375a3"
  end

  head do
    url "https:github.comstevegrubblibcap-ng.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "m4" => :build
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  # Compat for latest swig, removing deprecated `%except` directive
  # https:github.comstevegrubblibcap-ngcommit30453b6553948cd05c438f9f509013e3bb84f25b
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python3"
    system "make", "install", "py3execdir=#{prefixLanguage::Python.site_packages(python3)}"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `.test`
    system python3, "-c", "import capng"
  end
end

__END__
diff --git abindingssrccapng_swig.i bbindingssrccapng_swig.i
index fcdaf18..fa85e13 100644
--- abindingssrccapng_swig.i
+++ bbindingssrccapng_swig.i
@@ -30,13 +30,6 @@
 
 %varargs(16, signed capability = 0) capng_updatev;
 
-%except(python) {
-  $action
-  if (result < 0) {
-    PyErr_SetFromErrno(PyExc_OSError);
-    return NULL;
-  }
-}
 #endif
 
 %define __signed__