class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://ghproxy.com/https://github.com/rdkit/rdkit/archive/Release_2023_09_1.tar.gz"
  sha256 "e0ff8e330c98b93ac8277a59b2369d9a38027afadb4f03bb34c6924d445f08d5"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61bdf8de08cf1a9612f52107e96734218005ffb06f79beda68e632cdfe2a5744"
    sha256 cellar: :any,                 arm64_ventura:  "848ac75e7d5e4d9ae9c392d3b03938386db0058442286b835e50052cccbf09b6"
    sha256 cellar: :any,                 arm64_monterey: "549b804201ddff07696bac1155c399793b0efdc4746e304072bdff5a556a5e6a"
    sha256 cellar: :any,                 sonoma:         "471690a7f4fc2f2cbfffdf7763af023a080b17d49ce484c9f4c40292d0644e2b"
    sha256 cellar: :any,                 ventura:        "f838cf3b96d13cd17634f6d52bf44e27afe3833fe253422b961793b815fec867"
    sha256 cellar: :any,                 monterey:       "21c6cf7559163004a6f894aacb0019a44aeb89e30cbac73972681420400381b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5bfc27459078461ea6d4e496a99a272803bb85ac8ff50acd265c0d083f949e"
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
  depends_on "python@3.11"

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