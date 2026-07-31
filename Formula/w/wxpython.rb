class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/5f/59/8da2f898b3e1772ba501e5108d7d7824175485731c9b5f79381cb1e682d0/wxpython-4.3.0.tar.gz"
  sha256 "33d17964ba7392a7d08d4cdfe6573ab331fe61b3ba2e281f202fd8b4e0ef7810"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e383f480538a6d28df4cc3a3f3d1d7d20753f14cc0d59ba95e72817fb4bac9b5"
    sha256 cellar: :any, arm64_sequoia: "bd79f38481aef45a07a1ab4464b693dacb5ef4a2380ae20088760010b38e7fca"
    sha256 cellar: :any, arm64_sonoma:  "5bb509c4c1bfb570e5babe08efed64c7d532b47e3b9345f33de7ac92ef360283"
    sha256 cellar: :any, sonoma:        "a3a402895a6a7adc64ed361b6dda8257f087432970d549a808fd87cbc9affb49"
    sha256               arm64_linux:   "02bae02e9a492d540b56c06fef876617ea69f6929034c9d08d9972866de1e264"
    sha256               x86_64_linux:  "75db43f2dca37ce35820e47ed1152bfc257bd99e6271e7ac6168c47dbef9d278"
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

  def python
    "python3.14"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python)
    ENV.cxx11
    ENV["DOXYGEN"] = formula_opt_bin("doxygen")/"doxygen"
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