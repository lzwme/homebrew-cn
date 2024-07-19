class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/d1/8e/1d0b941ce1151009c6d98a0a590a608f346d4d272ce95ca09ee2bbb592cd/setuptools-71.0.3.tar.gz"
  sha256 "3d8531791a27056f4a38cd3e54084d8b1c4228ff9cf3f2d7dd075ec99f9fd70d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d7d5a93d53982d025f37433571e0325c3f76738695a5682175a0a04c97d3572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7d5a93d53982d025f37433571e0325c3f76738695a5682175a0a04c97d3572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d7d5a93d53982d025f37433571e0325c3f76738695a5682175a0a04c97d3572"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7124610c84247e9d933220334ddcdb2543f1782402263e5be54cf966e3acfe4"
    sha256 cellar: :any_skip_relocation, ventura:        "b7124610c84247e9d933220334ddcdb2543f1782402263e5be54cf966e3acfe4"
    sha256 cellar: :any_skip_relocation, monterey:       "b7124610c84247e9d933220334ddcdb2543f1782402263e5be54cf966e3acfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aeffe0c5020e9abf4fe8e8cfc8fee75281d8cfb295595d82e61bb16161e642a"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end