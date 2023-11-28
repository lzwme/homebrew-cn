class PythonMdurl < Formula
  desc "URL utilities for markdown-it (a Python port)"
  homepage "https://github.com/executablebooks/mdurl"
  url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
  sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efb0c5b435c4fc22c4d1a0ad2468f3093026a48ab4c7d51f8a67407df2aec024"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92276e4e29292fdcc1e3a6bf5cacd6dacdbc8574b651ab7ba4d2d521bdd49d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f835f5c32fbaa7b0d4b442e50596edb5933c0a288672d99a2b36bf664c5d8aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbf37c5c5e75d793ab709f7fd94d81ac5042255f51349eefc2434dea93dddedb"
    sha256 cellar: :any_skip_relocation, ventura:        "517ab5d02e51a91fddf6f2056e35f1b165f059eac1234145db601e7f450cd706"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3b3a640b3df9c339b55abc8c80eb17ef07bba2b89122cecdeb35bc4015986e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc1696f5ab5ba5bb87c465fb11a022f225dba4ef9212575424202228788c6b3"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import mdurl"
    end
  end
end