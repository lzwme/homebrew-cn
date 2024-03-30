class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2024_03_1.tar.gz"
  sha256 "5afe78c3d3358fec83f891eb822c0ad07a40ce3709da58071892bce1ea56585b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "878f0bbf6c40231481cbb998e1f50f89e452267835a8af8fbcb522863fbad47f"
    sha256 cellar: :any,                 arm64_ventura:  "d53daec4a39c072e9a39e85ccdf1ed48bb6c3a90607cda602ebac66ab2ce7556"
    sha256 cellar: :any,                 arm64_monterey: "b540186f7ee64d5528f72d7fdf0c57d7b891d3e068c8c9871dc12653e70e4f02"
    sha256 cellar: :any,                 sonoma:         "b2d422db00cc1f3de7e87a6c96996694014c7b3512dccfb1d620369fd024c8b3"
    sha256 cellar: :any,                 ventura:        "54963e256614f2a194badeca790df47f79ea3bc8872553e5349fa1f140c27858"
    sha256 cellar: :any,                 monterey:       "4634d98cb5a13f7fe40ba7b22ed8f5385e328ad4f929a26a9e8be4f627856330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "791a40fb24a7d1cd6c83146ed7fab93a67e36d4f8bf4694adfc4b5691a2458c8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
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