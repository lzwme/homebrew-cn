class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https:www.percona.comsoftwaremysql-databasepercona-xtrabackup"
  url "https:downloads.percona.comdownloadsPercona-XtraBackup-LATESTPercona-XtraBackup-8.0.35-31sourcetarballpercona-xtrabackup-8.0.35-31.tar.gz"
  sha256 "c6bda1e7f983e5a667bff22d1d67d33404db4e741676d03c9c60bbd4b263cabf"
  license "GPL-2.0-only"
  revision 9

  livecheck do
    url "https:docs.percona.compercona-xtrabackuplatest"
    regex(href=.*?v?(\d+(?:[.-]\d+)+)\.htmli)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub((-\d+)\.0$, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "74fc518ff44900f5d7a8655dabef6a918d61be57ac834eae7d1e191c345f9d0a"
    sha256 arm64_sonoma:  "c49845a74be172b8e3e8c05279f37937fc66f047840ba68ed968373dada3b161"
    sha256 arm64_ventura: "07ac89eae43069436c2dcbdfaa18fefcda59c757a0283603cfa16a48bd9806ff"
    sha256 sonoma:        "f9d9e68d2c034033db20bbe6d9ed834b2d18b0e06efb93c2ecc4af78f3174401"
    sha256 ventura:       "31170bf64e849c5bdbf690ecd6d5044e7aa7140cb1bad0a6009de6120245b590"
    sha256 x86_64_linux:  "11f42f284efa4f1b4bb855b6aca9f97d13b13524d9886bfaa1b5222bb93ed7b4"
  end

  depends_on "bison" => :build # needs bison >= 3.0.4
  depends_on "cmake" => :build
  depends_on "libevent" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "abseil"
  depends_on "icu4c@76"
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib"
  depends_on "zstd"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"
  uses_from_macos "perl"

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libaio"
    depends_on "procps"
  end

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTNDevel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  # This is not part of the system Perl on Linux and on macOS since Mojave
  resource "DBI" do
    url "https:cpan.metacpan.orgauthorsidTTITIMBDBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https:cpan.metacpan.orgauthorsidDDVDVEEDENDBD-mysql-5.008.tar.gz"
    sha256 "a2324566883b6538823c263ec8d7849b326414482a108e7650edc0bed55bcd89"
  end

  # https:github.comperconapercona-xtrabackupblobpercona-xtrabackup-#{version}cmakeboost.cmake
  resource "boost" do
    url "https:boostorg.jfrog.ioartifactorymainrelease1.77.0sourceboost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https:github.comHomebrewhomebrew-test-botpull820
  patch :DATA

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[duktape libkmip lz4 rapidjson robin-hood-hashing]
    (buildpath"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }
    (buildpath"boost").install resource("boost")

    if OS.linux?
      # Disable ABI checking
      inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"

      # Work around build issue with Protobuf 22+ on Linux
      # Ref: https:bugs.mysql.combug.php?id=113045
      # Ref: https:bugs.mysql.combug.php?id=115163
      inreplace "cmakeprotobuf.cmake" do |s|
        s.gsub! 'IF(APPLE AND WITH_PROTOBUF STREQUAL "system"', 'IF(WITH_PROTOBUF STREQUAL "system"'
        s.gsub! ' INCLUDE REGEX "${HOMEBREW_HOME}.*")', ' INCLUDE REGEX "libabsl.*")'
      end
    end

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=libpercona-xtrabackupplugin
      -DINSTALL_MANDIR=shareman
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=#{buildpath}boost
      -DWITH_EDITLINE=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]
    # Work around build script incorrectly looking for procps on macOS.
    # Issue ref: https:jira.percona.combrowsePXB-3210
    cmake_args << "-DPROCPS_INCLUDE_DIR=devnull" if OS.mac?

    # Remove conflicting manpages
    rm (Dir["man*"] - ["manCMakeLists.txt"])

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # remove conflicting library that is already installed by mysql
    (lib"libmysqlservices.a").unlink
    # remove conflicting librariesheaders that are installed by percona-server
    (lib"libkmip.a").unlink
    (lib"libkmippp.a").unlink
    (include"kmip.h").unlink
    (include"kmippp.h").unlink

    ENV.prepend_create_path "PERL5LIB", buildpath"build_depslibperl5"

    resource("Devel::CheckLib").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}build_deps"
      system "make", "install"
    end

    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    # This is not part of the system Perl on Linux and on macOS since Mojave
    if OS.linux? || MacOS.version >= :mojave
      resource("DBI").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec"bin", PERL5LIB: libexec"libperl5")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end

__END__
diff --git aCMakeLists.txt bCMakeLists.txt
index 42e63d0..5d21cc3 100644
--- aCMakeLists.txt
+++ bCMakeLists.txt
@@ -1942,31 +1942,6 @@ MYSQL_CHECK_RAPIDJSON()
 MYSQL_CHECK_FIDO()
 MYSQL_CHECK_FIDO_DLLS()

-IF(APPLE)
-  GET_FILENAME_COMPONENT(HOMEBREW_BASE ${HOMEBREW_HOME} DIRECTORY)
-  IF(EXISTS ${HOMEBREW_BASE}includeboost)
-    FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
-      IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-        MESSAGE(FATAL_ERROR
-          "WITH_${SYSTEM_LIB}=system is not compatible with Homebrew boost\n"
-          "MySQL depends on ${BOOST_PACKAGE_NAME} with a set of patches.\n"
-          "Including headers from ${HOMEBREW_BASE}include "
-          "will break the build.\n"
-          "Please use WITH_${SYSTEM_LIB}=bundled\n"
-          "or do 'brew uninstall boost' or 'brew unlink boost'"
-          )
-      ENDIF()
-    ENDFOREACH()
-  ENDIF()
-  # Ensure that we look in usrlocalinclude or opthomebrewinclude
-  FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
-    IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-      INCLUDE_DIRECTORIES(SYSTEM ${HOMEBREW_BASE}include)
-      BREAK()
-    ENDIF()
-  ENDFOREACH()
-ENDIF()
-
 IF(WITH_AUTHENTICATION_FIDO OR WITH_AUTHENTICATION_CLIENT_PLUGINS)
   IF(WITH_FIDO STREQUAL "system" AND
     NOT WITH_SSL STREQUAL "system")