class PythonConfigobj < Formula
  desc "Config file reading, writing and validation"
  homepage "https://configobj.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
  sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d2fe34d7ea0901e9b8daa11746fa46ce20d196df6a0c8d97b076ba4b6782c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8fd295cf3a5354c6083fdfc030fbe21bbcd18c69d8eab0ffd377c5b77e2651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbda7df424b93e1c17e4f968263262f3f263dd56bf3e5052ec391374e52b1550"
    sha256 cellar: :any_skip_relocation, sonoma:         "a97f0b2087187504695f6563510b13c23191caba176b1e31abef9d69ee875794"
    sha256 cellar: :any_skip_relocation, ventura:        "132e410162cf9da0e0032a0830418e3f0b125747f2f6d876f86c57cca0981b13"
    sha256 cellar: :any_skip_relocation, monterey:       "a25b723cdd46f0394d204578ae47f495eca95ec66aaa262223a616b3b90f613e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c2e358a53548ccc4303b84db9516c4599a52e2c72627c08d50606c74cf8ea9"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

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
      system python_exe, "-c", "from configobj import ConfigObj"
    end
  end
end