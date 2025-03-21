class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https:rpm.org"
  url "https:ftp.osuosl.orgpubrpmreleasesrpm-4.19.xrpm-4.19.1.1.tar.bz2"
  sha256 "874091b80efe66f9de8e3242ae2337162e2d7131e3aa4ac99ac22155e9c521e5"
  license "GPL-2.0-only"
  version_scheme 1
  head "https:github.comrpm-software-managementrpm.git", branch: "master"

  # Upstream uses a 90+ patch to indicate prerelease versions (e.g., the
  # tarball for "RPM 4.19 ALPHA" is `rpm-4.18.90.tar.bz2`).
  livecheck do
    url "https:rpm.orgdownload.html"
    regex(href=.*?rpm[._-]v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*))\.ti)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "13c5452de71ad6162ef07c7712a9419734da128ea6c1d443abb7756a2a105551"
    sha256 arm64_sonoma:  "dd2ff5b5bb9efbe1fff85619dd3d221291eb530f7d94558867c981a170bb54e4"
    sha256 arm64_ventura: "64e55e92671e5947a51e69aaa7e95fad907f8b9790cc8481414e31144a6640c0"
    sha256 sonoma:        "fda6009a2e5190fd74e8edb9cf8fe46d001d2fcacd71265eeb8c133b351cb3ae"
    sha256 ventura:       "983e017cd82c4a2ff5b150fa9755c2a948d4e9566eccf216e407f29a568764f1"
    sha256 arm64_linux:   "388a121f14d978c518bed065849a455c86bfb253871a48eaec3b7f9051c365d4"
    sha256 x86_64_linux:  "66c98e854bc22abb034a74b2bbb44fcf3332c5a783250a971fc38f43768aa596"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gawk" => :build
  depends_on "python@3.13" => [:build, :test]

  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  # See https:github.comrpm-software-managementrpmissues2222 for details.
  depends_on macos: :ventura
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "popt"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "rpm2cpio", because: "both install `rpm2cpio` binaries"

  def python3
    "python3.13"
  end

  def install
    ENV.append "LDFLAGS", "-lomp" if OS.mac?

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scriptspkgconfigdeps.sh",
              "usrbinpkg-config", Formula["pkgconf"].opt_bin"pkg-config"

    # work around Homebrew's prefix scheme which sets Python3_SITEARCH outside of prefix
    inreplace "pythonCMakeLists.txt", "${Python3_SITEARCH}", prefixLanguage::Python.site_packages(python3)

    # WITH_INTERNAL_OPENPGP and WITH_OPENSSL are deprecated
    rpaths = [rpath, rpath(source: lib"rpm")]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_SHAREDSTATEDIR=#{var}lib
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_NLS=ON
      -DENABLE_PLUGINS=OFF
      -DWITH_AUDIT=OFF
      -DWITH_INTERNAL_OPENPGP=ON
      -DWITH_OPENSSL=ON
      -DWITH_SELINUX=OFF
      -DRPM_VENDOR=#{tap.user}
      -DENABLE_TESTSUITE=OFF
      -DWITH_ACL=OFF
      -DWITH_CAP=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  def post_install
    (var"librpm").mkpath
    safe_system bin"rpmdb", "--initdb" unless (var"librpmrpmdb.sqlite").exist?
  end

  test do
    ENV["HOST"] = "test"
    (testpath".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)rpmbuild
      %_tmppath	%_topdirtmp
    EOS

    system bin"rpmdb", "--initdb", "--root=#{testpath}"
    system bin"rpm", "-vv", "-qa", "--root=#{testpath}"
    assert_path_exists testpathvar"librpmrpmdb.sqlite", "Failed to create 'rpmdb.sqlite' file"

    %w[SPECS BUILD BUILDROOT].each do |dir|
      (testpath"rpmbuild#{dir}").mkpath
    end
    specfile = testpath"rpmbuildSPECStest.spec"
    specfile.write <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     DevelopmentTools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      echo "hello brew" > test

      %install
      install -d $RPM_BUILD_ROOT%_docdir
      cp test $RPM_BUILD_ROOT%_docdirtest

      %files
      %_docdirtest

      %changelog

    EOS
    system bin"rpmbuild", "-ba", specfile
    assert_path_exists testpath"rpmbuildSRPMStest-1.0-1.src.rpm"
    assert_path_exists testpath"rpmbuildRPMSnoarchtest-1.0-1.noarch.rpm"

    info = shell_output(bin"rpm --query --package -i #{testpath}rpmbuildRPMSnoarchtest-1.0-1.noarch.rpm")
    assert_match "Name        : test", info
    assert_match "Version     : 1.0", info
    assert_match "Release     : 1", info
    assert_match "Architecture: noarch", info
    assert_match "Group       : DevelopmentTools", info
    assert_match "License     : Public Domain", info
    assert_match "Source RPM  : test-1.0-1.src.rpm", info
    assert_match "Trivial test package", info

    files = shell_output(bin"rpm --query --list --package #{testpath}rpmbuildRPMSnoarchtest-1.0-1.noarch.rpm")
    assert_match (HOMEBREW_PREFIX"sharedoctest").to_s, files

    system python3, "-c", "import rpm"
  end
end