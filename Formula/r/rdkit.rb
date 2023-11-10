class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://ghproxy.com/https://github.com/rdkit/rdkit/archive/refs/tags/Release_2023_09_1.tar.gz"
  sha256 "e0ff8e330c98b93ac8277a59b2369d9a38027afadb4f03bb34c6924d445f08d5"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7395ef0eb724c497b1af71168fd73ade87558e7249f4840970b9e0855283800"
    sha256 cellar: :any,                 arm64_ventura:  "31e3de4f1c58a09244ef08026064785879fa02f0069e630e1efec14b637ea27c"
    sha256 cellar: :any,                 arm64_monterey: "489ef08d1accf7ce44d2333cb56e0635bc08a43fbdd3d40e242e05322bcb7c91"
    sha256 cellar: :any,                 sonoma:         "7b2002155ff92dff7ff8701b088c956c6ffe37396e1bff41a17ea643dcc7cd63"
    sha256 cellar: :any,                 ventura:        "34a0d94d7a54766c2a87b6682517ff8f83499b30d147a96119c0f6dd9ca9f64b"
    sha256 cellar: :any,                 monterey:       "1ff28f2f3a508ad87af8f8bc104251d5d1382489827c2f6837592640cf5c6a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5142494251129331669559333892095faca5068a9880003c044317b3f64077"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@15"
  depends_on "py3cairo"
  depends_on "python@3.12"

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
  end

  # Get Python location
  def python_executable
    python.opt_libexec/"bin/python"
  end

  def postgresql
    Formula["postgresql@15"]
  end

  def install
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    py3ver = Language::Python.major_minor_version python_executable
    py3prefix = if OS.mac?
      python.opt_frameworks/"Python.framework/Versions"/py3ver
    else
      python.opt_prefix
    end
    py3include = py3prefix/"include/python#{py3ver}"
    site_packages = Language::Python.site_packages(python_executable)
    numpy_include = Formula["numpy"].opt_prefix/site_packages/"numpy/core/include"

    pg_config = postgresql.opt_bin/"pg_config"
    postgresql_lib = Utils.safe_popen_read(pg_config, "--pkglibdir").chomp
    postgresql_include = Utils.safe_popen_read(pg_config, "--includedir-server").chomp

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
      -DPostgreSQL_LIBRARY=#{postgresql_lib}
      -DPostgreSQL_INCLUDE_DIR=#{postgresql_include}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefix/site_packages/"homebrew-rdkit.pth").write libexec/site_packages
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME/.bashrc:
        export RDBASE=#{opt_share}/RDKit
    EOS
  end

  test do
    system python_executable, "-c", "import rdkit"
    (testpath/"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{python_executable} test.py 2>&1")
  end
end