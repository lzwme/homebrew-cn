class PythonXlsxwriter < Formula
  desc "Python module for creating Excel XLSX files"
  homepage "https:xlsxwriter.readthedocs.io"
  url "https:files.pythonhosted.orgpackages2ba3dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3XlsxWriter-3.1.9.tar.gz"
  sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "387bba010ad4f0eca2dad9eafb45f5ded13f91e86af36934178feb21ae3a0891"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6df2722e78790936ed6ad3c5faec23173dc8bb0891c96f096af41f6e9d63a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e375b775d72db3afdae5f03bfa897179e911020bba30df8eaab1fdc1f24338"
    sha256 cellar: :any_skip_relocation, sonoma:         "82124b76dbccdda2e20d304a710a448c4cc8db8ba0292ea1025676cda8a8f5d7"
    sha256 cellar: :any_skip_relocation, ventura:        "4217d1e6b732d1470f761c72c69a9aeb7595ddc209a9427b61bceeb91f26034b"
    sha256 cellar: :any_skip_relocation, monterey:       "a8669f6285f2b60194265e6751410728899d0657af32aaca638a7960f9abf5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a104c08da3293246846c929215b2ccb1206fcbf312ec9893af96f4ffc2e35180"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    bin.install_symlink "vba_extract.py" => "vba_extract"
  end

  def caveats
    <<~EOS
      To run `vba_extract`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    resource "homebrew-test_file" do
      url "https:github.comjmcnamaraXlsxWriterraw47afb63a79bb89a2c291c982cd9301e10d0be214xlsxwritertestcomparisonxlsx_filesmacro01.xlsm"
      sha256 "09c35d1580eb6d7e678ba8249cdd1cbc0bd245fbb0eed8794981728715944736"
    end

    testpath.install resource("homebrew-test_file")

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import xlsxwriter"
    end

    assert_match "Extracted: vbaProject.bin", shell_output("#{bin}vba_extract macro01.xlsm")
    assert_predicate testpath"vbaProject.bin", :exist?
  end
end