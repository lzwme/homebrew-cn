class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/3d/dd/026f6286f8beefcdd9551ad2e05b4e3edb45e638cdc067db211c53c950ce/wxpython-4.3.1.tar.gz"
  sha256 "4e3a95b63175be8e10f0662de506a36d8cc6cb86ecc5b30ae880c8dafb34a0cd"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83fa059b54cdd2d5714eb6dfb71caa7b9a69de493db1cc1a0d9ab8d05441324b"
    sha256 cellar: :any, arm64_tahoe:       "fb977bc8f8c01c9943df6cf26abab0e0abb3debe22653e99782819ca9f66cd1b"
    sha256 cellar: :any, arm64_sequoia:     "724c6dc1e3616fe016a16ec4b692044d709f4be20f6267b5e583523a3108d9df"
    sha256               arm64_linux:       "2d54a48cc89d843f585d9752e08a0b0c8ee9aa27cf5590cdff1010e45bb71a51"
    sha256               x86_64_linux:      "cfd784a9121c9f921bd93c0be1984be5617f9725f61c5099fa292eeb5e13a145"
  end

  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  # Upstream pins Doxygen 1.9.1, which keeps `constexpr` in the XML type; ours is newer
  # and reports it as an attribute, so `constexpr` members get a setter and fail to build.
  patch :DATA

  # Fix Doxygen binding generation, upstream PR ref, https://github.com/wxWidgets/Phoenix/pull/2963
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/911bd596087a4be61aa1da6654e2e4410f30a461.patch?full_index=1"
    sha256 "90c3c3273efdc7d5f9239e2b3f462ca7e9b564fc62ac0311dfa603f909a1122c"
    type :unofficial
  end

  # Declare the SIP ABI requirement, upstream PR ref, https://github.com/wxWidgets/Phoenix/pull/2964
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/169e00e00824bb68af6b66b951f7dc082ffe9c7f.patch?full_index=1"
    sha256 "864eebaef96a87cb6ff5cc911a550b08e7795ebfc0d1de763750e6af6338b57e"
    type :unofficial
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)
    ENV.cxx11
    ENV["DOXYGEN"] = formula_opt_bin("doxygen")/"doxygen"
    system python3, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python3, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python3} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/etgtools/extractors.py b/etgtools/extractors.py
index 5c3b1d4..b6e9b2d 100644
--- a/etgtools/extractors.py
+++ b/etgtools/extractors.py
@@ -222,6 +222,8 @@ class VariableDef(BaseDef):
     def extract(self, element):
         super(VariableDef, self).extract(element)
         self.type = flattenNode(element.find('type'))
+        if element.get('constexpr') == 'yes' and not self.type.startswith('const'):
+            self.type = 'const ' + self.type
         self.definition = element.find('definition').text
         self.argsString = element.find('argsstring').text