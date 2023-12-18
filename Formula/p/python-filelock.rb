class PythonFilelock < Formula
  desc "Platform-independent file lock for Python"
  homepage "https:github.comtox-devfilelock"
  url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
  sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21f0a81b7622d4a6890eee389b75a86e7166889f020b05d2f59401ae7482368e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfa0f219445ee220dc40ccfb7b91cfa3799e8e07e2a93a6fbf4e0331d5b76863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e206c90b7dd9b62dad72a7b4d789d78c660ff6e3fe31737c2f484db16d65d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "948badf6e608becab88cd0f9de6616177e960e5b9d6c0e21ddb0d7223e5e1151"
    sha256 cellar: :any_skip_relocation, ventura:        "8c6e6c63aa512f598dbec0f5a8eeeae8387e148118cf71b18bc46de763f387ca"
    sha256 cellar: :any_skip_relocation, monterey:       "c6c0773ec8d4abe10f065a2aa1fcadfbcd91a91aca0a54419c62372ecf378943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0008b9b0a9715c7aa91717595d8f8d19bef9cb7ef2fef08aabebe092784f020f"
  end

  depends_on "python-build" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "build", "--wheel", "."
      system python_exe, "-m", "pip", "install", *std_pip_args, Dir["distfilelock-*.whl"].first
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "from filelock import FileLock"
    end
  end
end