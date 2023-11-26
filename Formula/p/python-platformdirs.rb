class PythonPlatformdirs < Formula
  desc "Python package for determining appropriate platform-specific dirs"
  homepage "https://platformdirs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
  sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dbfd601fe9ad95b413d1efaff8fa47b75849de5401a3b65b3efd43d046d6896"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88a895a0137dcb19241fe0779fab0a96a67248d5cfe6accb2327dc8465170b0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "288ca4152c87c78ea5fa18e4af6f9481b8903b8e3834fd5965c718ba9c45515b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2286ee5074be3db0fc47d11fe1e0d91bf21504f8dfc4b4d3af5ab4050bd89639"
    sha256 cellar: :any_skip_relocation, ventura:        "76da2f8f8e06b4f039b607a9bed9ae89da088d0a4caafe438eaf711e5fbb02f5"
    sha256 cellar: :any_skip_relocation, monterey:       "2dba55c41d943efd3ef51c9442a803073a6a909912a4be526d24db6ce4c44778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000f0915dff3116eec89dc83134183855539cfcddcecab2b5d1d63b52a63df63"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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
      system python_exe, "-c", "import platformdirs"
    end
  end
end