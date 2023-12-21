class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https:github.comlxmllxml"
  url "https:files.pythonhosted.orgpackages8414c2070b5e37c650198de8328467dd3d1681e80986f81ba0fea04fc4ec9883lxml-4.9.4.tar.gz"
  sha256 "b1541e50b78e15fa06a2670157a1962ef06591d4c998b998047fff5e3236880e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26fe16e39037eff8a5af5e8ca32a1943314073ae6d3e9414d4f52d1192837376"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d833d5c3e8e3a9b858bbe8438066c7057f72cea1e5f0007282e7d596188a4664"
    sha256 cellar: :any,                 arm64_monterey: "8785e28d4e834ec934c01a90464f5993748e48071e9f73648e7f2e7ce7bd06ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "efc0d35e0eb519b6ac1900e7d252b6ec24fcc998d462e9ea487264e393a8a1df"
    sha256 cellar: :any_skip_relocation, ventura:        "1db1e9d71ba96d538ff411dcb39ee7ebef4f30c15078ab693afbedb79ccc5aaf"
    sha256 cellar: :any,                 monterey:       "250ff64b88807b7d6d86a28ae0b7db5c792a171f872ce202e7af1335d5944f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75e45ef233a41739a941593bd8e74e2223d667ec42cc046bced29f794456a69"
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