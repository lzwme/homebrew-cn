class Etl < Formula
  desc "Extensible Template Library"
  homepage "https:synfig.org"
  url "https:downloads.sourceforge.netprojectsynfigdevelopment1.5.2ETL-1.5.2.tar.gz"
  mirror "https:github.comsynfigsynfigreleasesdownloadv1.5.2ETL-1.5.2.tar.gz"
  sha256 "98d428d4a2b3e3f17469d3da35d1f9f488c57cedbe6a934fee5c684c0ff4030f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?ETL[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c052b60f8a2e21a109351218fa2d1402f6bf28c66e1695f3aba77a26dc959b2"
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  # upstream bug report, https:github.comsynfigsynfigissues3371
  patch :DATA

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <ETLmisc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    CPP
    flags = %W[
      -I#{include}ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system ".test"
  end
end

__END__
diff --git aconfiginstall-sh bconfiginstall-sh
index e046efd..ec298b5 100755
--- aconfiginstall-sh
+++ bconfiginstall-sh
@@ -1,4 +1,4 @@
-#!usrbinsh
+#!binsh
 # install - install a program, script, or datafile

 scriptversion=2020-11-14.01; # UTC