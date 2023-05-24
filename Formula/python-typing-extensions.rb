class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/e4/03/4670b4c206e1dc869f2f0120c3d0a2b17d42526ab2b5a8f66d4cd8642ef3/typing_extensions-4.6.0.tar.gz"
  sha256 "ff6b238610c747e44c268aa4bb23c8c735d665a63726df3f9431ce707f2aa768"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2943d134d186c466e155ddd04e8174eff895b4b50c7c2043846eb7672796aef1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010337b43aa565f06beb0f02ab95cc49931c09c5e498733f3f721166b4a66c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aba7b4fe414628a11db062641763b82dd334a5b06abcfc485c03e3e95dd53363"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba0199a9e7a3945bb6ed941dec50334250a9b99646950a6a2744ff086b1abd7"
    sha256 cellar: :any_skip_relocation, monterey:       "9ab9094479007d29edf2c4b78eb2d098284574a0591dd0bc5c6d3b80ea4c9ae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "65acde64a943daffa9af3f7f6bea491e037b6ff0a039b1775512dcac854f317b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f83690f4f9cfc2f7d24836bfd8054d453e3120ac64064077a26eea1b92be352"
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