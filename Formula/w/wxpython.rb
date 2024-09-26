class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https:www.wxpython.org"
  url "https:files.pythonhosted.orgpackagesa4f58c272764770f47fd419cc2eff4c4fa1c0681c71bcc2f3158b3a83d1339ffwxPython-4.2.2.tar.gz"
  sha256 "5dbcb0650f67fdc2c5965795a255ffaa3d7b09fb149aa8da2d0d9aa44e38e2ba"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_sequoia: "cd858733c842c47cf8bdadb8e6ef9e7edb8ce6ca9239b2b93bb7850b6f274b52"
    sha256 cellar: :any, arm64_sonoma:  "c051ef7032b0805c682cc083bb3ba745a6aa0698a267fc9f5b5f094e6178391a"
    sha256 cellar: :any, arm64_ventura: "ca9adadcaecf521c53885ee9520645275a3ee39721eaab9e9ee5f94069840e98"
    sha256 cellar: :any, sonoma:        "afcad2109bcd2a6fcf15574ed910bcc223b29f128049f70d5137029f7605b214"
    sha256 cellar: :any, ventura:       "a1c07cfabbde601d9709e12d8e342463c0b1f08e236cbb68525d5ca14db1aafc"
    sha256               x86_64_linux:  "f5b4d763fe0f40739cf512fef40190608454d59a3c5c28249dd6942b59a25849"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # build patch to build with doxygen 1.11.0+, remove in next release
  # upstream commit ref, https:github.comwxWidgetswxWidgetscommit2d79dfc7a2a8dd42021ff0ea3dcc8ed05f7c23ef
  patch :DATA

  def python
    "python3.12"
  end

  def install
    ENV.cxx11
    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end

__END__
diff --git aextwxWidgetsincludewxdatetime.h bextwxWidgetsincludewxdatetime.h
index 6eb2f8c..8c3cf43 100644
--- aextwxWidgetsincludewxdatetime.h
+++ bextwxWidgetsincludewxdatetime.h
@@ -148,7 +148,7 @@ public:
         Local,

          zones from GMT (= Greenwich Mean Time): they're guaranteed to be
-         consequent numbers, so writing something like `GMT0 + offset' is
+         consequent numbers, so writing something like `GMT0 + offset` is
          safe if abs(offset) <= 12

          underscore stands for minus
diff --git aextwxWidgetsinterfacewxdatetime.h bextwxWidgetsinterfacewxdatetime.h
index ae99947..4604b75 100644
--- aextwxWidgetsinterfacewxdatetime.h
+++ bextwxWidgetsinterfacewxdatetime.h
@@ -96,7 +96,7 @@ public:

         @{
          zones from GMT (= Greenwich Mean Time): they're guaranteed to be
-         consequent numbers, so writing something like `GMT0 + offset' is
+         consequent numbers, so writing something like `GMT0 + offset` is
          safe if abs(offset) <= 12

          underscore stands for minus