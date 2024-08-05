class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https:www.percona.comsoftwaremysql-databasepercona-xtrabackup"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https:downloads.percona.comdownloadsPercona-XtraBackup-LATESTPercona-XtraBackup-8.0.35-31sourcetarballpercona-xtrabackup-8.0.35-31.tar.gz"
  sha256 "c6bda1e7f983e5a667bff22d1d67d33404db4e741676d03c9c60bbd4b263cabf"
  license "GPL-2.0-only"
  revision 1

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
    sha256 arm64_sonoma:   "b5c06024f4c828b0f32b02ffae20618aaf49f68f29ea6e76447e78e8ea4dad95"
    sha256 arm64_ventura:  "2ed8789709352a980495715cbea9250df93ea6dce312d5467f6291725630941c"
    sha256 arm64_monterey: "e4d5dcf4b5a416efaaf07d84dbecb7947ce4bc7a300cbb1bf8312db6c97d512f"
    sha256 sonoma:         "a571ccf5981b0ca05d3ddf313ac273191b52f0a88ce757c7b1d9f2e29ab08be1"
    sha256 ventura:        "94ac98979fb87f800d8dd9e473d3a27825b20263895a5a8b78ee78239bd10696"
    sha256 monterey:       "463d67d569e0ee402ef0192f6c6c51d485c955e50c73398c1c224bce7e710812"
    sha256 x86_64_linux:   "9b680005cf3231ce6a6760aa4e580af5fe90be024702f9eb939815a0bc25b017"
  end

  depends_on "bison" => :build # needs bison >= 3.0.4
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icu4c"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "protobuf@21"
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

  fails_with :gcc do
    version "6"
    cause "The build requires GCC 7.1 or later."
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
    # Disable ABI checking
    inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=libpercona-xtrabackupplugin
      -DINSTALL_MANDIR=shareman
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]
    # Work around build script incorrectly looking for procps on macOS.
    # Issue ref: https:jira.percona.combrowsePXB-3210
    cmake_args << "-DPROCPS_INCLUDE_DIR=devnull" if OS.mac?

    (buildpath"boost").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}boost"

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