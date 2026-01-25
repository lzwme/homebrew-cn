class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/80/6e/b70e6dbdd7cb4f154b7ca424b4c7799f7b067f7a9f4204b8d16d6464648f/wxpython-4.2.4.tar.gz"
  sha256 "2eb123979c87bcb329e8a2452269d60ff8f9f651e9bf25c67579e53c4ebbae3c"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db15d20d907d4b47a4f3299e451654ec0ceb860bb0bd1c7657929b1a9bbea515"
    sha256 cellar: :any, arm64_sequoia: "b0e6a63175089f14f8004fdfd3b4c0a80e82858beb32ba85a1a974eeafc95637"
    sha256 cellar: :any, arm64_sonoma:  "066b996fe3e01e05e35378e317b69c94338118b94ba1e5c1c9cc1dc1a6235b3f"
    sha256 cellar: :any, sonoma:        "f8ae96134fffc11eafa913097ab936bfb1cdabee62fedbf5eb174abfc22a2f06"
    sha256               arm64_linux:   "9bd17d5c9692d44a57a0ce29e6ee157625a4ad4a0f59d9f5a94d0a896b85ebd5"
    sha256               x86_64_linux:  "01505ad8c5b9421ea073ee37da2c68ce5a10dbc78d2ec45d1ee79444e7c7bdd7"
  end

  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "wxwidgets@3.2" # issue ref: https://github.com/wxWidgets/Phoenix/issues/2764

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  def python
    "python3.14"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python)
    ENV.cxx11
    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin/"doxygen"
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