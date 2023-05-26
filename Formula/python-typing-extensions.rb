class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/be/fc/3d12393d634fcb31d5f4231c28feaf4ead225124ba08021046317d5f450d/typing_extensions-4.6.2.tar.gz"
  sha256 "06006244c70ac8ee83fa8282cb188f697b8db25bc8b4df07be1873c43897060c"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "344b0bf12b5ebc80f0de1bd98e215aed5c005b3858caf6c5998c89456513de71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ad421c1b51363a4bd68cbd82d65e2e6ff1a95dfa49ffba7f8ad53c430bf715"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d5de681b343c5dc388e700e9db2e9e7558c01196d78e25f16e64ef1359793d6"
    sha256 cellar: :any_skip_relocation, ventura:        "c03312b8e8958a1bc48e475b751b84f850d3543f3c21f5b50ebbd0f6a1804b09"
    sha256 cellar: :any_skip_relocation, monterey:       "b82c9a997669fe894d5c322c57c06cbfacd72c8bec588265cb7112e1be73cc1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7326c2c25fb257a038994848459bd8aa26219336745123910707078be9bb915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cc4b137b02eacc0e8b6110c65f3b1251eb8abd450f0eb96cc3053b59ee8073"
  end

  depends_on "flit" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "mypy" => :test

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    system Formula["flit"].opt_bin/"flit", "build", "--format", "wheel"
    wheel = Pathname.glob("dist/typing_extensions-*.whl").first
    pip_flags = %W[
      --verbose
      --isolated
      --no-deps
      --no-binary=:all:
      --ignore-installed
      --prefix=#{prefix}
    ]
    pythons.each do |python|
      pip = python.opt_libexec/"bin/pip"
      system pip, "install", *pip_flags, wheel
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `typing_extensions` module for Python #{python_versions}.
      If you need `typing_extensions` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import typing_extensions
      EOS
    end

    (testpath/"test.py").write <<~EOS
      import typing_extensions

      class Movie(typing_extensions.TypedDict):
          title: str
          year: typing_extensions.NotRequired[int]

      m = Movie(title="Grease")
    EOS
    mypy = Formula["mypy"].opt_bin/"mypy"
    system mypy, testpath/"test.py"
  end
end