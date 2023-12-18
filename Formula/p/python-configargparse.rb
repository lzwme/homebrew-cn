class PythonConfigargparse < Formula
  desc "Drop-in replacement for argparse"
  homepage "https:github.combw2ConfigArgParse"
  url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
  sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7f579dbc4a406c6c627bff3f7d839b6e31eeec727cf0e53247662cf70d981ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69a568fcbe47d72c10310b811b944d4a4b8d16e608a6c7e9f8d5242888b87f26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70ea94ee276a3e4e234cd59af437b6515ac5a4b8eed2b5e45efa6c39615614e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b40b485061b2dcef2814acb7ce81595ba5a7947cbac8774d761c5fac93624f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f1f2596a391a3ddfc2e302babebe3b9a7663f1a2ce38c185a19fb28dd6c117"
    sha256 cellar: :any_skip_relocation, monterey:       "f6431819a7a81bd1ce856c6dab7dba8b087b65191cf9bcfda023d51488089d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db5f412ca93b57f9285f2f8e4ef37e262476eaf17b414378f29af1bf334600a"
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
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import configargparse"
    end
  end
end