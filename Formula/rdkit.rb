class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://ghproxy.com/https://github.com/rdkit/rdkit/archive/refs/tags/Release_2023_03_1.tar.gz"
  sha256 "db346afbd0ba52c843926a2a62f8a38c7b774ffab37eaf382d789a824f21996c"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c80b611887f75ce2d065c5c9e9a1b24beca2d90d8e5c4fafb465ff244f19629f"
    sha256 cellar: :any,                 arm64_monterey: "2f287b59609a5d608f6de8885e217a37f3bdd84041ed68cc3aef5d1c7cf233cc"
    sha256 cellar: :any,                 arm64_big_sur:  "f128b5eb71680bf11fc20f42155bcaa2b792d028fc6268f0e9a84ff0521eb370"
    sha256 cellar: :any,                 ventura:        "0c1e5c0e8966f498d9f13932bddd022c25aa44005424f77e9bec9200b45da70f"
    sha256 cellar: :any,                 monterey:       "277e6a95188201d1d45bad737583aa33624ebc94f5378208a02e04e0c0cff2cf"
    sha256 cellar: :any,                 big_sur:        "d283960533b78804af3bda64b21881b535d01ba94864f9aa308b31b0b3e4c871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49e3d564c7c0a2c6dc66c270d850ca64e8db2fde1b5745ea8a1f6d4a5722434"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@14"
  depends_on "py3cairo"
  depends_on "python@3.11"

  # Fixes `error: call to undeclared function` in YAeHMOP
  # Remove in next release
  patch do
    url "https://github.com/rdkit/rdkit/commit/181a29c2953a679fc8a6a22722fe667e2823ebad.patch?full_index=1"
    sha256 "01e3560824931e19420caf21690e0066f553a7ba4fd59b4263db8e2ad8bc1e0c"
  end

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
  end

  # Get Python location
  def python_executable
    python.opt_libexec/"bin/python"
  end

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV.cxx11
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