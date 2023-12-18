class PythonRegex < Formula
  desc "Alternative regular expression module, to replace re"
  homepage "https:github.commrabarnettmrab-regex"
  url "https:files.pythonhosted.orgpackages6b3849d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0dregex-2023.10.3.tar.gz"
  sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70ed42547ca53647309afcf5ed38c36e9bcd193fbdf4225db2e72b733c431abd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "355660c688953cdb9fe945fe9ad8c2e802018b56d4d0645993631f0e9f2339af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92a8c538cc82dff0f5d236f51ad9b8736781a345667518b943552740500d6061"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a615fff69e490e0295ab620caeb66e285a2d05664908dc3bc48d30b9fde9569"
    sha256 cellar: :any_skip_relocation, ventura:        "d2cbbec9b7b37f8cdd1bb80af531e0090db41d285b5d6347f979acdff90467be"
    sha256 cellar: :any_skip_relocation, monterey:       "fb80b72442f3500cf44486e31f53fdd98a2640d3b4cb7cb3346ba2d5df0cb414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a22202c8cf9ffbf0504f4542583abf55d75d490f8c1a605573a3fe1f735ab64c"
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
      system python_exe, "-c", "import regex; print(regex.sub('.*', 'x', 'test'))"
    end
  end
end