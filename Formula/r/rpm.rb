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
    rebuild 1
    sha256 arm64_sequoia: "39c91308dcd8fad7a1a2837e30c995b5a6d549c15dd5588919934a17d8661ac7"
    sha256 arm64_sonoma:  "67ba99b7cd54a54ffe9d4e796ba945e4904246d80fad9db4f2a14f0e1fb5a5bf"
    sha256 arm64_ventura: "2c4154695367e44ba42ef63657f982be51f112d58c70f4ce0820e023b5cc6229"
    sha256 sonoma:        "90955f283776a74e8a473776cdf8b4799aac9bbc5599256712ed0ccc9267356d"
    sha256 ventura:       "00422982de3adedc6ce6dbdc8167f2309a7891e4f482ad78d066638c9121dcb4"
    sha256 x86_64_linux:  "67f635814320965ab61fd82e699b5b3e9d2a9d3774b7cdc78dc5d994b80ce33f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gawk" => :build
  depends_on "python@3.12" => [:build, :test]

  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  # See https:github.comrpm-software-managementrpmissues2222 for details.
  depends_on macos: :ventura
  depends_on "openssl@3"
  depends_on "pkg-config"
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
    "python3.12"
  end

  def install
    ENV.append "LDFLAGS", "-lomp" if OS.mac?

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scriptspkgconfigdeps.sh",
              "usrbinpkg-config", Formula["pkg-config"].opt_bin"pkg-config"

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
    assert_predicate testpathvar"librpmrpmdb.sqlite", :exist?,
                     "Failed to create 'rpmdb.sqlite' file"

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
    assert_predicate testpath"rpmbuildSRPMStest-1.0-1.src.rpm", :exist?
    assert_predicate testpath"rpmbuildRPMSnoarchtest-1.0-1.noarch.rpm", :exist?

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