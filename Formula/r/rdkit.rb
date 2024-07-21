class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2024_03_5.tar.gz"
  sha256 "b0870aec4dca12da5ee1100a769eaf4c71c3a6f99339f8aa72d30affc068a632"
  license "BSD-3-Clause"
  head "https:github.comrdkitrdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(^Release[._-](\d+(?:[._]\d+)+)$i)
    strategy :git do |tags|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89616883da8051184a529d5ca1faa03f59bbff570630ba1b226679743c039ca7"
    sha256 cellar: :any,                 arm64_ventura:  "2572d06717dbe97295283dcb16b7b035a269efa218b6da28678441bcddf6a1a7"
    sha256 cellar: :any,                 arm64_monterey: "66151c0cd7c5e207533ae2ecd0172b81bab626408d3257df56f12be0444709ea"
    sha256 cellar: :any,                 sonoma:         "f64064cc6ba59c4b53eae3074d2db524cfb159b6593ca0f6704f3bf72486ad48"
    sha256 cellar: :any,                 ventura:        "9f2ca439e69897b8dd65a0c44b527a6b06096f10f36b3f0d1c422bf6e68cb531"
    sha256 cellar: :any,                 monterey:       "e2b068b75ec4b56403931778351352a23408fb6e0e92e5c8db93a792e696622f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d520d92e67fd6723fa812fb553a01c4493f7fcf5873f0acb7efbfa2630479a7"
  end

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairo"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@14"
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
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("postgresql@") }
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
    numpy_include = Formula["numpy"].opt_prefixsite_packages"numpy_coreinclude"

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
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME.bashrc:
        export RDBASE=#{opt_share}RDKit
    EOS
  end

  test do
    # Test Python module
    system python_executable, "-c", "import rdkit"
    (testpath"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{python_executable} test.py 2>&1")

    # Test PostgreSQL extension
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin"pg_ctl"
    psql = postgresql.opt_bin"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath"test"
    (testpath"testpostgresql.conf").write <<~EOS, mode: "a+"

      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath"test", "-l", testpath"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"rdkit\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath"test"
    end
  end
end