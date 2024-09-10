class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https:github.comhylanghy"
  url "https:files.pythonhosted.orgpackages8853e92bfd8a36dc4a62e0922d409f703299eac8a0a74ed4db2106acad4f00a0hy-0.29.0.tar.gz"
  sha256 "1f985c92fddfb09989dd2a2ad75bf661efcbad571352eb5ee48c8b8e08f666fa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2c93fbd996b0bd4d2c4eaf52ec56a8559d657478bd6b79934d3e344b109477c"
  end

  depends_on "python@3.12"

  resource "funcparserlib" do
    url "https:files.pythonhosted.orgpackages9344a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  # Fix crash on python 3.12.6: https:github.comhylanghypull2599
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}hy test.hy")

    (testpath"test.py").write shell_output("#{bin}hy2py test.hy")
    assert_match "4", shell_output("#{libexec}binpython test.py")
  end
end

__END__
diff --git ahyimporter.py bhyimporter.py
index 554281e..f6087c3 100644
--- ahyimporter.py
+++ bhyimporter.py
@@ -99,7 +99,7 @@ def _get_code_from_file(run_name, fname=None, hy_src_check=lambda x: x.endswith(
                 source = f.read().decode("utf-8")
             code = compile(source, fname, "exec")

-    return (code, fname)
+    return code if sys.version_info >= (3, 12, 6) else (code, fname)


 importlib.machinery.SOURCE_SUFFIXES.insert(0, ".hy")