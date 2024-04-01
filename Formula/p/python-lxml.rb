class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https:github.comlxmllxml"
  url "https:files.pythonhosted.orgpackages70ecb14f525777646d9cdccb573cbfeb5f72682089892c826c60f054e7ddd110lxml-5.2.0.tar.gz"
  sha256 "21dc490cdb33047bc7f7ad76384f3366fa8f5146b86cc04c4af45de901393b90"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55b8bb14974d5c8cc63b44ff254a27d171fe01cab3e89a95d4aee270ac523129"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69d701a591ee90d5dade8876ed009a922b6f90be2ef2fa74a0ff0e2854a6ca5"
    sha256 cellar: :any,                 arm64_monterey: "337b9f2c4086e7098ca5e39cdc43a6df916d4c176d7bfaa789a5be74cdad395e"
    sha256 cellar: :any_skip_relocation, sonoma:         "73af114ad64a525d021f98e4d0f4f66d1e6f95c3d3731a8ff8b7fe77c70a1210"
    sha256 cellar: :any_skip_relocation, ventura:        "256256cb44b7456c84df077d4f08e86206f3cecf9af946fd308f3deaec4d7096"
    sha256 cellar: :any,                 monterey:       "07511b536fc7745925eb298070bc8f6672e31883dd2078d0453f229d3e42e610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c158339e6a385408e353181de3dc4c57a06368d8281cf83747dbed558ee91a"
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