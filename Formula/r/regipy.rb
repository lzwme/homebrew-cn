class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  # pypi missing `regipy.plugins.system.external` package, upstream pr, https://github.com/mkorman90/regipy/pull/309
  url "https://ghfast.top/https://github.com/mkorman90/regipy/archive/refs/tags/6.0.1.tar.gz"
  sha256 "5a2c7e87e714d39f16b746fabf953af40ad3f9fa19a8bab377e08e4bd6b7f7af"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4897e82b414d1b76a45a2776eac85e0ab21260fb0dfe9cdd0e6057e0c6add879"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "regipy[cli]"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/02/77/8c84b98eca70d245a2a956452f21d57930d22ab88cbeed9290ca630cf03f/construct-2.10.70.tar.gz"
    sha256 "4d2472f9684731e58cc9c56c463be63baa1447d674e0d66aeb5627b22f512c29"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  # add missing `regipy.plugins.system.external` package, upstream pr ref, https://github.com/mkorman90/regipy/pull/309
  patch :DATA

  def install
    virtualenv_install_with_resources

    cmds = %w[
      regipy-parse-header regipy-dump regipy-plugins-run
      regipy-plugins-list regipy-diff regipy-process-transaction-logs
    ]
    cmds.each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :click)
    end
  end

  test do
    resource "homebrew-test_hive" do
      url "https://ghfast.top/https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
      sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
    end

    testpath.install resource("homebrew-test_hive")

    system bin/"regipy-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
    h = JSON.parse(File.read("out.json"))
    assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
    assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index e090f68..8c2f61a 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -52,6 +52,7 @@ dev = [
     "mypy",
     "pre-commit",
     "tabulate",  # Required for plugin validation
+    "tomli; python_version < '3.11'",  # For test_packaging.py on Python 3.9/3.10
 ]

 [project.scripts]
@@ -68,7 +69,7 @@ Repository = "https://github.com/mkorman90/regipy/"
 Issues = "https://github.com/mkorman90/regipy/issues"

 [tool.setuptools]
-packages = ["regipy", "regipy.plugins", "regipy.plugins.ntuser", "regipy.plugins.system", "regipy.plugins.software", "regipy.plugins.sam", "regipy.plugins.security", "regipy.plugins.amcache", "regipy.plugins.bcd", "regipy.plugins.usrclass"]
+packages = ["regipy", "regipy.plugins", "regipy.plugins.ntuser", "regipy.plugins.system", "regipy.plugins.system.external", "regipy.plugins.software", "regipy.plugins.sam", "regipy.plugins.security", "regipy.plugins.amcache", "regipy.plugins.bcd", "regipy.plugins.usrclass"]
 include-package-data = true

 [tool.ruff]