class PythonMutagen < Formula
  desc "Python module for handling audio metadata"
  homepage "https://mutagen.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
  sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c52d112939a94f7ec1b2538da9bd7e8e91b60f2043555717141dff37e263c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7cf27ab591f44b3b376b13fcb1a6b1bf0e5be3a6c3d3254cc604ebbfaf599d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1fc3056ad539cc308c5b5f19c31f9fd1b4c41fcba147fe165e3135ab77ebdc8"
    sha256 cellar: :any_skip_relocation, ventura:        "18a6275854216ab9e6984b095ee52a5954b0b98c2438892aa0343eaf6d2e6882"
    sha256 cellar: :any_skip_relocation, monterey:       "53c34e668ab2169e79594fe913e1c81dfb90d7611d7d43cbbd4ca56cde929fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ef50fca99248247311662ebe6b699863edab65ccac0225c2ea558a78070600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa05ac3433c921b04bcc252fb61f2cc6b2c4f3bc4c58add60c40dadc59c2d264"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
      system python_exe, "-c", "from mutagen.id3 import ID3, TIT2"
    end
  end
end