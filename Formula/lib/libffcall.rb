class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  sha256 "8ef69921dbdc06bc5bb90513622637a7b83a71f31f5ba377be9d8fd8f57912c2"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "81b1425ddfbafc4b45ea81966453bb799882b8416e5afb12782188b8fbe187ec"
    sha256 cellar: :any,                 arm64_ventura:  "a8c90eb0454270ad27198e6e90c0731f6afef51095ec621b80a7a043754822e0"
    sha256 cellar: :any,                 arm64_monterey: "91b71a704643bddb2ccd847f70bca71b2f4f42f15dfbe090163efb30e834e9aa"
    sha256 cellar: :any,                 sonoma:         "dd054182feae02cb566f5e587b1a8d325207d08ee4aea65d0fc1dc6b63c5fb3e"
    sha256 cellar: :any,                 ventura:        "5f46b88ad65430756cb72c1d4998af731850e1c5b1a8ddd7867f08f7c574af34"
    sha256 cellar: :any,                 monterey:       "40160028f3394161521a252e488bd7aaa5d2f08f226c794d3252d0d5e1622d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f068599b3b97c24dba0ebe1338f972e5de443b155dd2a174dcd516d7b8a39430"
  end

  # Backport fix needed to build on Sonoma ARM
  on_arm do
    on_sonoma :or_newer do
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build

      patch :DATA # minimal diff to apply following commit
      patch do
        url "https://git.savannah.gnu.org/gitweb/?p=libffcall.git;a=patch;h=b35777b44209c0fa94f70320d9c7054220f31acb"
        sha256 "a120b64c77a8c493f6fc00545cc2c689cde16d009141590ad8fad0f0336124cc"
      end
    end
  end

  def install
    if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :sonoma
      cp Formula["libtool"].share.glob("aclocal/*"), buildpath/"m4"
      system "autoreconf", "--force", "--install", "--verbose", "-I", "gnulib-m4", "-I", "m4"
    end
    ENV.deparallelize
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~EOS
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    EOS
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end

__END__
diff --git a/ChangeLog b/ChangeLog
index eda04ef..0510f3e 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -1,3 +1,7 @@
+2024-07-12  Bruno Haible  <bruno@clisp.org>
+
+	Switch to autoconf 2.72, automake 1.17.
+
 2021-06-13  Bruno Haible  <bruno@clisp.org>

 	Prepare for 2.4 release.
diff --git a/NEWS b/NEWS
index 5911682..d3dc00e 100644
--- a/NEWS
+++ b/NEWS
@@ -1,3 +1,7 @@
+* Added support for the following platforms:
+  (Previously, a build on these platforms failed.)
+  - loongarch64: Linux with lp64d ABI.
+
 New in 2.4:

 * Added support for the following platforms:
diff --git a/callback/trampoline_r/trampoline.c b/callback/trampoline_r/trampoline.c
index 5d4f8c2..089ce24 100644
--- a/callback/trampoline_r/trampoline.c
+++ b/callback/trampoline_r/trampoline.c
@@ -1,7 +1,7 @@
 /* Trampoline construction */

 /*
- * Copyright 1995-2021 Bruno Haible <bruno@clisp.org>
+ * Copyright 1995-2022 Bruno Haible <bruno@clisp.org>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/m4/codeexec.m4 b/m4/codeexec.m4
index 4bf8a73..16a59af 100644
--- a/m4/codeexec.m4
+++ b/m4/codeexec.m4
@@ -1,5 +1,5 @@
 dnl -*- Autoconf -*-
-dnl Copyright (C) 1993-2020 Free Software Foundation, Inc.
+dnl Copyright (C) 1993-2023 Free Software Foundation, Inc.
 dnl This file is free software, distributed under the terms of the GNU
 dnl General Public License as published by the Free Software Foundation;
 dnl either version 2 of the License, or (at your option) any later version.
diff --git a/trampoline/trampoline.c b/trampoline/trampoline.c
index 9b79e0d..7147c5f 100644
--- a/trampoline/trampoline.c
+++ b/trampoline/trampoline.c
@@ -1,7 +1,7 @@
 /* Trampoline construction */

 /*
- * Copyright 1995-2021 Bruno Haible <bruno@clisp.org>
+ * Copyright 1995-2022 Bruno Haible <bruno@clisp.org>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by