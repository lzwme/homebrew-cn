class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https:rdkit.org"
  # NOTE: Make sure to update RPATHs if any "@rpath-referenced libraries" show up in `brew linkage`
  url "https:github.comrdkitrdkitarchiverefstagsRelease_2024_09_1.tar.gz"
  sha256 "034c00d6e9de323506834da03400761ed8c3721095114369d06805409747a60f"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e7de2819e18663a44f2671d735c0e9eee43a65c8744234434e7d0fbe5f7a9cf0"
    sha256 cellar: :any,                 arm64_sonoma:  "fe02041bae92cd4f30bb07a7b7eaf8f41380bea5441bf22493bb12b80582e79d"
    sha256 cellar: :any,                 arm64_ventura: "88eef74234bd10abcd81b396811840c67aaddd51ba588fca752a2a58f7020a48"
    sha256 cellar: :any,                 sonoma:        "3b348c2f9bca7425fe544a0e527232204b74fadf65225ff744cec03554af2f1b"
    sha256 cellar: :any,                 ventura:       "9e005669b34baa90269a9da960b37f192a015336cc3b36b72a048e1396851d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2728d26c52a5ce95b98e5f9354932c8556e3ffbde8ad6340af5fbc95b8be931"
  end

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairo"
  depends_on "coordgen"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "maeparser"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "python@3.12"

  # Apply open PR commit to use .dylib for PostgreSQL 16+ modules
  # TODO: Remove if merged and available in a release
  # PR ref: https:github.comrdkitrdkitpull7869
  patch do
    url "https:github.comrdkitrdkitcommit3ade0f8cd31be54fc267b9f5e94e8aa755f56f36.patch?full_index=1"
    sha256 "09696dc4c26832f5c5126d059ae0d71a12ab404438e55e8f9a90880a1fad6c03"
  end

  def python3
    "python3.12"
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    python_rpath = rpath(source: libLanguage::Python.site_packages(python3))
    python_rpaths = [python_rpath, "#{python_rpath}..", "#{python_rpath}...."]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_MODULE_LINKER_FLAGS=#{python_rpaths.map { |path| "-Wl,-rpath,#{path}" }.join(" ")}
      -DCMAKE_REQUIRE_FIND_PACKAGE_coordgen=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_maeparser=ON
      -DRDK_INSTALL_INTREE=OFF
      -DRDK_BUILD_SWIG_WRAPPERS=OFF
      -DRDK_BUILD_AVALON_SUPPORT=ON
      -DRDK_PGSQL_STATIC=OFF
      -DRDK_BUILD_INCHI_SUPPORT=ON
      -DRDK_BUILD_CPP_TESTS=OFF
      -DRDK_INSTALL_STATIC_LIBS=OFF
      -DRDK_BUILD_CAIRO_SUPPORT=ON
      -DRDK_BUILD_YAEHMOP_SUPPORT=ON
      -DRDK_BUILD_FREESASA_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which(python3)}
    ]
    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
      args << "-DRDK_OPTIMIZE_POPCNT=OFF"
    end
    system "cmake", "-S", ".", "-B", "build", "-DRDK_BUILD_PGSQL=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "CodePgSQLrdkitCMakeLists.txt" do |s|
      # Prevent trying to install into pg_config-defined dirs
      s.sub! "set(PG_PKGLIBDIR \"${PG_PKGLIBDIR}", "set(PG_PKGLIBDIR \"$ENV{PG_PKGLIBDIR}"
      s.sub! "set(PG_EXTENSIONDIR \"${PG_SHAREDIR}", "set(PG_EXTENSIONDIR \"$ENV{PG_SHAREDIR}"
      # Re-use installed libraries when building modules for other PostgreSQL versions
      s.sub!(^find_package\(PostgreSQL, "find_package(Cairo REQUIRED)\nfind_package(rdkit REQUIRED)\n\\0")
      s.sub! 'set(pgRDKitLibs "${pgRDKitLibs}${pgRDKitLib}', 'set(pgRDKitLibs "${pgRDKitLibs}RDKit::${pgRDKitLib}'
      # Add RPATH for PostgreSQL cartridge
      s.sub! '"-Wl,-dead_strip_dylibs ', "\\0-Wl,-rpath,#{loader_path}.. "
    end
    ENV["DESTDIR"] = "" # to force creation of non-standard PostgreSQL directories

    postgresqls.each do |postgresql|
      ENV["PG_PKGLIBDIR"] = libpostgresql.name
      ENV["PG_SHAREDIR"] = sharepostgresql.name
      builddir = "build_pg#{postgresql.version.major}"

      system "cmake", "-S", ".", "-B", builddir,
                      "-DRDK_BUILD_PGSQL=ON",
                      "-DPostgreSQL_ROOT=#{postgresql.opt_prefix}",
                      "-DPostgreSQL_ADDITIONAL_VERSIONS=#{postgresql.version.major}",
                      *args, *std_cmake_args
      system "cmake", "--build", "#{builddir}CodePgSQLrdkit"
      system "cmake", "--install", builddir, "--component", "pgsql"
    end
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables, e.g.
        #{Utils::Shell.export_value("RDBASE", "#{opt_share}RDKit")}
    EOS
  end

  test do
    # Test Python module
    (testpath"test.py").write <<~EOS
      from rdkit import Chem
      print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_equal "c1ccncc1", shell_output("#{python3} test.py 2>&1").chomp

    # Test PostgreSQL extension
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"rdkit\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end