class PythonToml < Formula
  desc "Python Library for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6049ee6f1f4a5fc61182b749b5c941495257c6330d4d2f7e2677dddeabee7138"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b902eca4c4ef2d390d91f3f5897bc7ed039ff6f282255f2692ab4b80ed1947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8cc37e45b92018ea82f224341844d1fec3e3d213ecd3b809fbff60157527ae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0163ac068c1c7e50e390f3fe6a10a2ca4eb89dd7a32b6c57934505a9e5a3e7e0"
    sha256 cellar: :any_skip_relocation, ventura:        "8b085cd82b0daf659a675ef5a8bb1d364f5fb70691c072d62b466bc2d1578190"
    sha256 cellar: :any_skip_relocation, monterey:       "5730e7676ccd19b5e903e60bf84ecb78c85e7407112dec8e6f74c079a93e11be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "202bc7b0d3efe28ae4fe8675bd96a41cf3c0f666ad54bd269902954393fc05d3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~PYTHON
        import toml
        toml_string = """
        title = "TOML Example"
        """
        parsed_toml = toml.loads(toml_string)
      PYTHON
    end
  end
end