class Pgrouting < Formula
  desc "Provides geospatial routing for PostGISPostgreSQL database"
  homepage "https:pgrouting.org"
  url "https:github.compgRoutingpgroutingreleasesdownloadv3.7.1pgrouting-3.7.1.tar.gz"
  sha256 "2ff432d392fa05784a1d0fe7d01cf4c1f474cdd4a0b7081fb69269970948c6b6"
  license "GPL-2.0-or-later"
  head "https:github.compgRoutingpgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7873c42ad734a8fb46c30a37a17cfe1abcb4c8e6663f50bbb5be90b786b830e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d11c777a7f4c0cc336f809df6e3f0a558497f766d12aa4bb2b0f2df3f1ccac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96f1b7ba76045af7530812c58739dd08f84489114b94878977d69b714c66fcf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb444264f526620686d055e3c235d41cd2dd74c3f954da6d911188e9c2153038"
    sha256 cellar: :any_skip_relocation, ventura:       "b9748459e27f475765cb5e1ea0a9c269227b963f9fa637b8395285452b71329a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a801b8ab4859586e61cd98e9105113e6eb4a9dcb20dc9bfccc489aec1cbf063"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgis"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    ENV["DESTDIR"] = buildpath"stage"

    postgresqls.each do |postgresql|
      builddir = "build-pg#{postgresql.version.major}"
      args = ["-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}pg_config"]
      # CMake MODULE libraries use .so on macOS but PostgreSQL 16+ looks for .dylib
      # Ref: https:github.compostgrespostgrescommitb55f62abb2c2e07dfae99e19a2b3d7ca9e58dc1a
      args << "-DCMAKE_SHARED_MODULE_SUFFIX_CXX=.dylib" if OS.mac? && postgresql.version >= 16

      system "cmake", "-S", ".", "-B", builddir, *args, *std_cmake_args
      system "cmake", "--build", builddir
      system "cmake", "--install", builddir
    end

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpathstage_path"lib").children
    share.install (buildpathstage_path"share").children
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin"pg_ctl"
      psql = postgresql.opt_bin"psql"
      port = free_port

      datadir = testpathpostgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end