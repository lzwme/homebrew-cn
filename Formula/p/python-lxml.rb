class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https:github.comlxmllxml"
  url "https:files.pythonhosted.orgpackages30397305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78lxml-4.9.3.tar.gz"
  sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a936346ac35c87286220f0cc1cf2d3464aebf3247008363973e23bbedecd5884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fff4c452cfc9b3a58a640fc0fcb59c83c2f2e20eddd86f904d0eff139190443a"
    sha256 cellar: :any,                 arm64_monterey: "ddb7a1cd1a97906ee45128ea137740bf11f5d64a873058d0026f4709e1ec140b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21c2e4a4bfd2d414a3414fdf9fbd9ea0951c67e33fb00f2d35560623a0fdfd6"
    sha256 cellar: :any_skip_relocation, ventura:        "0adbf87fbf7092c5778905f031635845d7f2c151ea66f692dd0f42ca294c30e7"
    sha256 cellar: :any,                 monterey:       "94a3e5283af927f957e20a79524abe9c4f3af8773e24d70a9b1621c34f0c513a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2cf15ba1d041ad8d1f3ef6fb6466bfca5233272fea0766f49c2940db88d3fc"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import lxml"
    end
  end
end