class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/3d/dd/026f6286f8beefcdd9551ad2e05b4e3edb45e638cdc067db211c53c950ce/wxpython-4.3.1.tar.gz"
  sha256 "4e3a95b63175be8e10f0662de506a36d8cc6cb86ecc5b30ae880c8dafb34a0cd"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b2504d738c9aad32c12a333d25adaef240da7f2219d53215db21411ed11d454d"
    sha256 cellar: :any, arm64_tahoe:       "31577157f3d007aba55a46d6142d1d8ebbf3def4c61e976d8fb17b1b20b4177a"
    sha256 cellar: :any, arm64_sequoia:     "b141ed8f2313c7f988622a3761657c493b2aab883e2f79be80652b297c933226"
    sha256               arm64_linux:       "e49558656cb3a04c7136148eaaff1bdc46746c2ca14764882d92ba3c633d0082"
    sha256               x86_64_linux:      "8db396922e0b4ebba03eb3eb0626b3ffa4eb4831ba1797b66d8a542f1da79bc6"
  end

  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.15"
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