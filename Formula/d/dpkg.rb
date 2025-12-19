class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  # Please use a mirror as the primary URL as the
  # dpkg site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.23.2.tar.xz"
  sha256 "c076d02672e33592d84ba130350db6f6ec08d0ffe0901645040e7bd309f76020"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dpkg/"
    regex(/href=.*?dpkg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f82209d5bafd09f2ace85b16db2c191e04e07b8c205fe9002c59d10e9ab776dd"
    sha256 arm64_sequoia: "3892a5df473c1d15a866d75562dfa618fa36d573d3462d961c2024c549559e96"
    sha256 arm64_sonoma:  "562cd3c1b50423f02fabb23f30458e5b22d7350d9b08bb736851781afd791bf0"
    sha256 sonoma:        "4700d5705cf461a93058137c1341a2d28bd8920d786ad97c672487a6a861e31b"
    sha256 arm64_linux:   "bd6eeef3f6383c4727036c859feb6de41119d7e1ad6c9da82b7f327cb842f32d"
    sha256 x86_64_linux:  "e869a840c3768dea28c0fb8d9d3ef8ea6be431fbd19d42ec39a738023cd37268"
  end

  depends_on "pkgconf" => :build
  depends_on "po4a" => :build
  depends_on "gettext"
  depends_on "gnu-tar"
  depends_on "gpatch"
  depends_on "libmd" # for md5.h
  depends_on "perl"
  depends_on "xz" # For LZMA

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with system dpkg"
  end

  patch :DATA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = if OS.mac?
      Formula["gnu-tar"].opt_bin/"gtar"
    else
      Formula["gnu-tar"].opt_bin/"tar"
    end

    # Since 1.18.24 dpkg mandates the use of GNU patch to prevent occurrences
    # of the CVE-2017-8283 vulnerability.
    # https://www.openwall.com/lists/oss-security/2017/04/20/2
    ENV["PATCH"] = if OS.mac?
      Formula["gpatch"].opt_bin/"gpatch"
    else
      Formula["gpatch"].opt_bin/"patch"
    end

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-start-stop-daemon"
    system "make"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    man.install Dir[libexec/"share/man/*"]
    (lib/"pkgconfig").install_symlink Dir[libexec/"lib/pkgconfig/*.pc"]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])

    (buildpath/"dummy").write "Vendor: dummy\n"
    (pkgetc/"origins").install "dummy"
    (pkgetc/"origins").install_symlink "dummy" => "default"
    (var/"lib/dpkg").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      This installation of dpkg is not configured to install software, so
      commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end

  test do
    # Do not remove the empty line from the end of the control file
    # All deb control files MUST end with an empty line
    (testpath/"test/data/homebrew.txt").write "brew"
    (testpath/"test/DEBIAN/control").write <<~EOS
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system bin/"dpkg", "-b", testpath/"test", "test.deb"
    assert_path_exists testpath/"test.deb"

    rm_r("test")
    system bin/"dpkg", "-x", "test.deb", testpath
    assert_path_exists testpath/"data/homebrew.txt"
  end
end

__END__
diff --git a/lib/dpkg/i18n.c b/lib/dpkg/i18n.c
index 4952700..81533ff 100644
--- a/lib/dpkg/i18n.c
+++ b/lib/dpkg/i18n.c
@@ -23,6 +23,11 @@

 #include <dpkg/i18n.h>

+#ifdef __APPLE__
+#include <string.h>
+#include <xlocale.h>
+#endif
+
 #ifdef HAVE_USELOCALE
 static locale_t dpkg_C_locale;
 #endif