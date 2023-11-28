class PythonCachetools < Formula
  desc "Extensible memoizing collections and decorators"
  homepage "https://cachetools.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
  sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6930df55fcc056b66d2c77ee1158792b7b4c562ee3513e289846bcfda34ebdb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd20fabf7e62c959b9527fdb878d6f04b284ae23be3f8e8e535947b89dc30f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beba1128ac7f461d8903f6310d129f939f1d763ec3ae2d8be960a25af0210eab"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5880f58fa6b0dbdd863f753e6adfcb62354fe57e17953f0dec502937def881b"
    sha256 cellar: :any_skip_relocation, ventura:        "a328895b4ea991353964ac0d235919aaa3b30587f3909910bbd4d6c9f10b6d31"
    sha256 cellar: :any_skip_relocation, monterey:       "09c07db11f40c83e39febdbf8e29c6ea27a152f2128373f465085a09d276ba24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414eb0b2a78508cc94cc90852957432e9fcadb7af561bf1bf438571a91d5d299"
  end

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "from cachetools import cached, LRUCache, TTLCache"
    end
  end
end