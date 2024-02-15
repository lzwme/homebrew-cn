class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2023_09_5.tar.gz"
  sha256 "0b1ddf2bf822879e0863caf8efb794154e0a424108f2c1333ac94381c01fd688"
  license "BSD-3-Clause"
  head "https:github.comrdkitrdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(^Release[._-](\d+(?:[._]\d+)+)$i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9280a09f3592761087ca9f1aa24da6eac5b7e12a1f63bc1165eaf5a9439b20e"
    sha256 cellar: :any,                 arm64_ventura:  "657251b9b5eb9a678108c357dea88dd66628107df294fdecf75dfec72999218c"
    sha256 cellar: :any,                 arm64_monterey: "7d3dd965c123bb2d7dabfad7cfa949bba3972457467c5dbe74ce8fada1f8331c"
    sha256 cellar: :any,                 sonoma:         "7870ff2c626dd0a3c5c0be172c2889f83884a9cf1e470a161c05ab20696f65b5"
    sha256 cellar: :any,                 ventura:        "a60323fced6b6118afbf65f78d6b2559847171363cfaa97e66531de877991caf"
    sha256 cellar: :any,                 monterey:       "fd748b8e8a1cd138dda933eebbfc74636235592062110083c18dd1323b8b0de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1446e8789356a1ff132eed3a4837f0f12a8820c284f1845363c38a273004d9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@16"
  depends_on "py3cairo"
  depends_on "python@3.12"

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(^python@\d\.\d+$) }
  end

  # Get Python location
  def python_executable
    python.opt_libexec"binpython"
  end

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    py3ver = Language::Python.major_minor_version python_executable
    py3prefix = if OS.mac?
      python.opt_frameworks"Python.frameworkVersions"py3ver
    else
      python.opt_prefix
    end
    py3include = py3prefix"includepython#{py3ver}"
    site_packages = Language::Python.site_packages(python_executable)
    numpy_include = Formula["numpy"].opt_prefixsite_packages"numpycoreinclude"

    # Prevent trying to install into pg_config-defined dirs
    inreplace "CodePgSQLrdkitCMakeLists.txt" do |s|
      s.gsub! "set(PG_PKGLIBDIR \"${PG_PKGLIBDIR}", "set(PG_PKGLIBDIR \"#{libpostgresql.name}"
      s.gsub! "set(PG_EXTENSIONDIR \"${PG_SHAREDIR}", "set(PG_EXTENSIONDIR \"#{sharepostgresql.name}"
    end
    ENV["DESTDIR"] = "" # to force creation of non-standard PostgreSQL directories

    # set -DMAEPARSER and COORDGEN_FORCE_BUILD=ON to avoid conflicts with some formulae i.e. open-babel
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DRDK_INSTALL_INTREE=OFF
      -DRDK_BUILD_SWIG_WRAPPERS=OFF
      -DRDK_BUILD_AVALON_SUPPORT=ON
      -DRDK_BUILD_PGSQL=ON
      -DRDK_PGSQL_STATIC=ON
      -DMAEPARSER_FORCE_BUILD=ON
      -DCOORDGEN_FORCE_BUILD=ON
      -DRDK_BUILD_INCHI_SUPPORT=ON
      -DRDK_BUILD_CPP_TESTS=OFF
      -DRDK_INSTALL_STATIC_LIBS=OFF
      -DRDK_BUILD_CAIRO_SUPPORT=ON
      -DRDK_BUILD_YAEHMOP_SUPPORT=ON
      -DRDK_BUILD_FREESASA_SUPPORT=ON
      -DBoost_NO_BOOST_CMAKE=ON
      -DPYTHON_INCLUDE_DIR=#{py3include}
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_NUMPY_INCLUDE_PATH=#{numpy_include}
      -DPostgreSQL_CONFIG=#{postgresql.bin}pg_config
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefixsite_packages"homebrew-rdkit.pth").write libexecsite_packages
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME.bashrc:
        export RDBASE=#{opt_share}RDKit
    EOS
  end

  test do
    system python_executable, "-c", "import rdkit"
    (testpath"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{python_executable} test.py 2>&1")
  end
end