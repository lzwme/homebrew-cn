class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.net/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.3.tar.xz"
  sha256 "74b95302e24dbebc56e97048e86ad0a4121fc82a43e58d381fbe1d380e8eba04"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "96eda1d9b060aa8e57f747b313e6f3a549841dcd89e94b77a4a65aecb8f1b975"
    sha256 cellar: :any, arm64_sequoia: "ea4bb7ccf2905b3c6d0bcb737a0df4c68c6f1d74aa0a40a7e85358fb8babecfa"
    sha256 cellar: :any, arm64_sonoma:  "8ed9c8aeafaa5c37a6c883ebc7d91c1a419bb2181bb98e6e6930061967362069"
    sha256 cellar: :any, arm64_ventura: "7ee27c6995a0afb593127e45a431c1a2ac2a2e9c45897c3ce9a960e7f574e41b"
    sha256 cellar: :any, sonoma:        "eb848276ab7187fe00cdb41076afa5ebd82b81b3acf6bfb70b6b0553f68c9868"
    sha256 cellar: :any, ventura:       "fa93706f20eea80fcecd503fe8760b6613b9b46997ad49be56f75c046036aeb7"
    sha256               arm64_linux:   "4c97756368be0322715581ae867af7e4a6684a55d3fbf3c07759873422a28b43"
    sha256               x86_64_linux:  "aa6277a0000377577cd64566aea608746cf3b6e748e3aea17964bf6d36276e95"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glibmm@2.66"

  uses_from_macos "libxml2"

  # Fix naming clash with libxml macro.
  # Backport of: https://github.com/libxmlplusplus/libxmlplusplus/pull/74
  patch :DATA

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs libxml++-2.6").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/libxml++/parsers/textreader.cc b/libxml++/parsers/textreader.cc
index 223dd9a..c80b0f4 100644
--- a/libxml++/parsers/textreader.cc
+++ b/libxml++/parsers/textreader.cc
@@ -19,7 +19,7 @@ public:
   int Int(int value);
   bool Bool(int value);
   char Char(int value);
-  Glib::ustring String(xmlChar* value, bool free = false);
+  Glib::ustring String(xmlChar* value, bool should_free = false);
   Glib::ustring String(xmlChar const* value);
 
   TextReader & owner_;
@@ -403,7 +403,7 @@ char TextReader::PropertyReader::Char(int value)
   return value;
 }
 
-Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool free)
+Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool should_free)
 {
   owner_.check_for_exceptions();
   
@@ -412,7 +412,7 @@ Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool free)
     
   const Glib::ustring result = (char *)value;
 
-  if(free)
+  if(should_free)
     xmlFree(value);
 
   return result;