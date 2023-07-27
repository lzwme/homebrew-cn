class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/65/0e/f3ecc15f1f9dbd95ecdf1cd3246712ae13920d9665c3dbed089cd5d12d3b/MapProxy-1.16.0.tar.gz"
  sha256 "a11157be4729d1ab40680af2ce543fffcfebd991a5fa676e3a307a93fbc56d6b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c8baf6fed9ddd4ccee9777ddc56ef4f25715761ad64e14d47d611149667346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b0315d558265e6f2041458917ed5e450cb8ba0b8b52ff54d1f20fb889912b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e2bd10f1406677a0d79114f296a7356cf1850687e53d58aaba7fc9c90978f8"
    sha256 cellar: :any_skip_relocation, ventura:        "7327c1a3f131cdb60e52d3603879d5879c2b1845985ce4cd8932f6ebe9bb175b"
    sha256 cellar: :any_skip_relocation, monterey:       "6215b8d6c202441d569b1baedc04493bc39cf4dc9193d15180644fb4f93c262f"
    sha256 cellar: :any_skip_relocation, big_sur:        "856b84981891fa41918496e849c9ec472635b34a599f486364c929a48ed62795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060d147b19171d74d321781bf331a36a9a249df976ff13004b1808a239f56267"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/38/77/46fe6a107b934fd23b903cb7402b69c8b2480a6cab9481d9f98c6dc7726e/pyproj-3.6.0.tar.gz"
    sha256 "a5b111865b3f0f8b77b3983f2fbe4dd6248fc09d3730295949977c8dcd988062"

    # Patch to build with cython 3+, remove in 3.6.1+
    # upstream commit ref, https://github.com/pyproj4/pyproj/commit/1452ba404be58c14a6b64d4551c320022f5aafcf
    patch :DATA
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end

__END__
diff --git a/pyproj/_datadir.pxd b/pyproj/_datadir.pxd
index 07ec85f..a5cfd2c 100644
--- a/pyproj/_datadir.pxd
+++ b/pyproj/_datadir.pxd
@@ -1,7 +1,7 @@
 include "proj.pxi"
 
-cpdef str _get_proj_error()
-cpdef void _clear_proj_error()
+cpdef str _get_proj_error() noexcept
+cpdef void _clear_proj_error() noexcept
 cdef PJ_CONTEXT* PYPROJ_GLOBAL_CONTEXT
 cdef PJ_CONTEXT* pyproj_context_create() except *
 cdef void pyproj_context_destroy(PJ_CONTEXT* context) except *
diff --git a/pyproj/_datadir.pyx b/pyproj/_datadir.pyx
index 4675aa3..15439dd 100644
--- a/pyproj/_datadir.pyx
+++ b/pyproj/_datadir.pyx
@@ -6,7 +6,6 @@ from libc.stdlib cimport free, malloc
 
 from pyproj._compat cimport cstrencode
 
-from pyproj.exceptions import DataDirError
 from pyproj.utils import strtobool
 
 # for logging the internal PROJ messages
@@ -79,14 +78,14 @@ def get_user_data_dir(create=False):
     )
 
 
-cpdef str _get_proj_error():
+cpdef str _get_proj_error() noexcept:
     """
     Get the internal PROJ error message. Returns None if no error was set.
     """
     return _INTERNAL_PROJ_ERROR
 
 
-cpdef void _clear_proj_error():
+cpdef void _clear_proj_error() noexcept:
     """
     Clear the internal PROJ error message.
     """
@@ -94,7 +93,7 @@ cpdef void _clear_proj_error():
     _INTERNAL_PROJ_ERROR = None
 
 
-cdef void pyproj_log_function(void *user_data, int level, const char *error_msg) nogil:
+cdef void pyproj_log_function(void *user_data, int level, const char *error_msg) nogil noexcept:
     """
     Log function for catching PROJ errors.
     """
diff --git a/pyproject.toml b/pyproject.toml
index fc3f284..29e91a0 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -1,5 +1,5 @@
 [build-system]
-requires = ["setuptools>=61.0.0", "wheel", "cython>=0.28.4"]
+requires = ["setuptools>=61.0.0", "wheel", "cython>=3"]
 build-backend = "setuptools.build_meta"
 
 [project]