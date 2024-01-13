class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2023_09_2.tar.gz"
  sha256 "d6ed9e0cdf231550fa850070be7ea53154d46ec6cf32a9b5fd5fec2d34a60c6b"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ac57e6dac73a6b151866e63447949734964305bdcb3400356c8878a3773e9a34"
    sha256 cellar: :any,                 arm64_ventura:  "cdd596a9b439974545125a07450c4c37a59bca11821598329b0c44c869c12e10"
    sha256 cellar: :any,                 arm64_monterey: "b62d5da3527e291cb7aaf402c64897afaaf7e1580f6704abf9ff2d04ca7c0109"
    sha256 cellar: :any,                 sonoma:         "716926ec85af64ed6e2deec047ffcf1d55d0fc0bd6c2c4d3c57b0d5cfd92b9f7"
    sha256 cellar: :any,                 ventura:        "6b47bea3c2f9b66cc2580267a34f2e906dc775eeb460314a2be15e7b9bdd23ac"
    sha256 cellar: :any,                 monterey:       "d9dbce7c5af17de953424cdcdffac4271eb3128bd86b015382405a08c3d84f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5cbec69e5921c174dae2ad362536f1f76f6abdaebf499d054f469bac093a688"
  end

  depends_on "cmake" => :build
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
      -DPostgreSQL_CONFIG=#{postgresql.opt_libexec}binpg_config
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