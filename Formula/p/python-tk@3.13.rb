class PythonTkAT313 < Formula
  desc "Python interface to TclTk"
  homepage "https:www.python.org"
  url "https:www.python.orgftppython3.13.4Python-3.13.4.tgz"
  sha256 "2666038f1521b7a8ec34bf2997b363778118d6f3979282c93723e872bcd464e0"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5e6807439625285dd5a53a045d7a4b65d7cd82ad66bc87809258902f4a9bb1dc"
    sha256 cellar: :any, arm64_sonoma:  "c10bfa46bbfcde6551a5991d10fc2b03600ddf5371a84972e6f9eecc1fda9974"
    sha256 cellar: :any, arm64_ventura: "ea32e90251da993a7e61a4cef2bd453ff26ff7102020b10cf9fb915cabde2c2c"
    sha256 cellar: :any, sonoma:        "88d0aee2a6d625f7ffb25efbcdde15a2e1b883bb64b3c38203ec29fdecc4f5b7"
    sha256 cellar: :any, ventura:       "f01a7794e659ceb4208de288aeacc46fc7dcc143675d6b0a4119b0f909fc0f6e"
    sha256               arm64_linux:   "be636493c1d38b83d7e95f61a315de8ba61072d6c7515b41c36214e3c82dabec"
    sha256               x86_64_linux:  "d0d66790343518e42f86bbdf73c83513830e69061cf9b38987ec7da0ab54e840"
  end

  depends_on "python@3.13"
  depends_on "tcl-tk"

  def python3
    "python3.13"
  end

  # Apply commit from open PR to fix TCL 9 threaded detection
  # PR ref: https:github.compythoncpythonpull128103
  patch do
    url "https:github.compythoncpythoncommita2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
  end

  # Backport of https:github.compythoncpythoncommit47cbf038850852cdcbe7a404ed7c64542340d58a
  # TODO: Remove if https:github.compythoncpythonpull127364 is merged and released
  patch :DATA

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks"Python.frameworkVersions#{xy}includepython#{xy}"
    else
      Formula["python@#{xy}"].opt_include"python#{xy}"
    end

    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1), ("TCL_WITH_EXTERNAL_TOMMATH", 1)],
                          include_dirs=["#{python_include}internal", "#{Formula["tcl-tk"].opt_include"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end

__END__
diff --git aLibtkinterttk.py bLibtkinterttk.py
index 073b3ae20797c3..8ddb7f97e3b233 100644
--- aLibtkinterttk.py
+++ bLibtkinterttk.py
@@ -321,6 +321,8 @@ def _tclobj_to_py(val):
     elif hasattr(val, 'typename'): # some other (single) Tcl object
         val = _convert_stringval(val)

+    if isinstance(val, tuple) and len(val) == 0:
+        return ''
     return val

 def tclobjs_to_py(adict):
diff --git aModules_tkinter.c bModules_tkinter.c
index b0b70ccb8cc3d3..45897817a56051 100644
--- aModules_tkinter.c
+++ bModules_tkinter.c
@@ -325,6 +325,7 @@ typedef struct {
     const Tcl_ObjType *ListType;
     const Tcl_ObjType *StringType;
     const Tcl_ObjType *UTF32StringType;
+    const Tcl_ObjType *PixelType;
 } TkappObject;

 #define Tkapp_Interp(v) (((TkappObject *) (v))->interp)
@@ -637,6 +638,7 @@ Tkapp_New(const char *screenName, const char *className,
     v->ListType = Tcl_GetObjType("list");
     v->StringType = Tcl_GetObjType("string");
     v->UTF32StringType = Tcl_GetObjType("utf32string");
+    v->PixelType = Tcl_GetObjType("pixel");

     * Delete the 'exit' command, which can screw things up *
     Tcl_DeleteCommand(v->interp, "exit");
@@ -1236,7 +1238,8 @@ FromObj(TkappObject *tkapp, Tcl_Obj *value)
     }

     if (value->typePtr == tkapp->StringType ||
-        value->typePtr == tkapp->UTF32StringType)
+        value->typePtr == tkapp->UTF32StringType ||
+        value->typePtr == tkapp->PixelType)
     {
         return unicodeFromTclObj(tkapp, value);
     }