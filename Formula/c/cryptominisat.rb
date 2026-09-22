class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://ghfast.top/https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.16.0.tar.gz"
  sha256 "e3a02fe9a1a13ede75b6e52866ca2cc98032d134cd7ccaadabc07b9977df4908"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7816f28f00e59959221fcd33b7ff37867e54170d10a0a3c1bd60ae346ccf1cc"
    sha256 cellar: :any, arm64_tahoe:       "98ebe46a40908ef24c9cf4441c0337c4e1179ddcae1741c4b8d7238b7ab5d586"
    sha256 cellar: :any, arm64_sequoia:     "293d7bc4197647f06eef022efcc2e3ff59d621d0f2b601e201cec7468410f033"
    sha256 cellar: :any, arm64_linux:       "e041606e2e6251b1ca3d1f3b320fe6ee01f34e3623593a4b875c8a607cba36ef"
    sha256 cellar: :any, x86_64_linux:      "a3e1534f5349db87df55327a06944d7332ad63eecc642a08a0d5809b994acef4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://ghfast.top/https://github.com/meelgroup/cadical/archive/818c9562f114b315a9246ced943b66b60b38e8fb.tar.gz"
    version "818c9562f114b315a9246ced943b66b60b38e8fb"
    sha256 "beaeb17a751db88d5384b35d65be82501d94cf60f758b768b59bfb2b437cb34b"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://ghfast.top/https://github.com/meelgroup/cadiback/archive/47a6d821085ef8cb033241659824beafeb798cff.tar.gz"
    version "47a6d821085ef8cb033241659824beafeb798cff"
    sha256 "ccc2faf23c78ba22e2c73bb8c8ebe33995083dce77ee0ca8eb7ee3009955d9c4"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadiback", "locked", "rev")
      end
    end
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # Build static libraries as these are only installed into `buildpath` to link into cryptominisat
    resource("cadical").stage do
      inreplace "src/cadical_gitsha1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

      args = ["-DBUILD_SHARED_LIBS=OFF"]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"cadical")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("cadiback").stage do
      inreplace "CMakeLists.txt", 'set(CADIBACK_BUILD "${CMAKE_CXX_COMPILER}")', "set(CADIBACK_BUILD \"#{ENV.cxx}\")"

      args = ["-DBUILD_SHARED_LIBS=OFF", "-Dcadical_DIR=#{buildpath}/cadical"]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"cadiback")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      -DBUILD_PYTHON_EXTENSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}
      -DMIT=ON
      -Dcadical_DIR=#{buildpath}/cadical
      -Dcadiback_DIR=#{buildpath}/cadiback
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    site_packages.install prefix.glob("pycryptosat.*.so")
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end