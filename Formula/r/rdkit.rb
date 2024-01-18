class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2023_09_4.tar.gz"
  sha256 "abacae431bbc5882b87cc8629b7ddc02757204e854aa45b6157ec2bf45d623ef"
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
    sha256 cellar: :any,                 arm64_sonoma:   "535bb6868e735a0147e4f3a77acd3802daad3a7bc8d0e86a634e5b371ded1c69"
    sha256 cellar: :any,                 arm64_ventura:  "15f070d4838f682844ee462dad9feae5768264f767292d2ee5e1c976597ac053"
    sha256 cellar: :any,                 arm64_monterey: "2d8d7e4adfad6636e82f90fc8b94eb5b46b14eb6b6856d937ee3afdc02daa699"
    sha256 cellar: :any,                 sonoma:         "2f4365b7693d080e19fce99a06ce0a29ec1c57b82ae2d6580ce2c333d5c6a4b2"
    sha256 cellar: :any,                 ventura:        "36fbed556bc6c3447793399a5e1451433b70a2f1549e90dcdcdfc4d01bddfd55"
    sha256 cellar: :any,                 monterey:       "9a8afdad3517684776d7d5d150fbe640500a26d6230e876480f748a206d01d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb507f66b1affa0bb07eb995683013d00961f62c8da7fd29c12fcf7ec1baa58e"
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