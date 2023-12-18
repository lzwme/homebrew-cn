class PythonDateutil < Formula
  desc "Useful extensions to the standard Python datetime features"
  homepage "https:github.comdateutildateutil"
  url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
  sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb7e7a8095b6ef0faa231cb385e2edf152f93bd8b6b201f8f0283975aa8a0c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e043c7c21453f6613a65aae1b44a61ced3a69cf4152e6a83374d0b483acc96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a45eb0c21908f79df8445fcef22c6b90d59c22d69d5e89679138a778623e1862"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca7324974470db0fb253c16f2a66c8131071a064425b3ea59e88b55111f10c76"
    sha256 cellar: :any_skip_relocation, ventura:        "634ed37fc5639de61617a6a5b373801057bf2ab3a6b0e373997dd77cce60c5bd"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8d9a4e6d6e0c13b7d3d2c599fc10eb55d9edbb27d45dbd3a6ffb226b2cc114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5cddb58045c1b708645154c609bf0e1f2bdc1634a12d933e072417a99681456"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

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
      system python_exe, "-c", "import dateutil"
    end
  end
end