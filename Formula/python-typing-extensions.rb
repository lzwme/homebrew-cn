class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/57/e3/b37a6b1ce6c1b2b75d05997ec24f73c794bc05a587e0f30a532d0ab13cb2/typing_extensions-4.7.0.tar.gz"
  sha256 "935ccf31549830cda708b42289d44b6f74084d616a00be651601a4f968e77c82"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e66c7b50230e8720b396849a4774f09f58ef615335189ce306362c84436450e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c475a71df87f72a366f3111a09f5f61829a7d80745fc81a9774b86868fe313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23289d9e2d527bd5bf57759c72f9e60a1945b4ab385583fbc6cdade422b57b85"
    sha256 cellar: :any_skip_relocation, ventura:        "4f01cdbcb054165520da3a218fd1c6c1d45acee2400502a4895f238454c2f3c3"
    sha256 cellar: :any_skip_relocation, monterey:       "057f8e9e083522bd0f077fbd0a1471723335e514774d85dd6cf11e4e92b396de"
    sha256 cellar: :any_skip_relocation, big_sur:        "5679b2de76d9ccd645aaaf0fe636d01df2567b3a19462009774f135f00721998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeddbedc96c1d3f50852a5d194fc719507a8e266cfd18311809b0b39f76c8f44"
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