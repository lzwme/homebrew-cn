class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
  sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83d13d953e029f0fbbfe5b461710426399c95edbb7c9c68b460d8a5a43532f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "284a01f2b18ada3cbc87e859e1ef222697f90be4d22b267be74af14c82121eb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d788ca899a256cc32931862ae2f4e87fdc3b10cf3c9e6843d2194acabb68ca13"
    sha256 cellar: :any_skip_relocation, sonoma:         "68bd1a263a10eba8963d4da2840f512fe2eb20b1b73d8f776efda91b059472a2"
    sha256 cellar: :any_skip_relocation, ventura:        "a742d1f2fc96ba730b33bed350b6d9899aa74a8a0eb68f908037c27195c3d8bd"
    sha256 cellar: :any_skip_relocation, monterey:       "994931b7afeede558f92088a739b628d7b0a67d8def32bf0e31504d2ee62a866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447f8149c3a67db2d820c2f7619b7a6121ba34ecbdf61428a33789006b926fff"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from markupsafe import escape"
    end
  end
end