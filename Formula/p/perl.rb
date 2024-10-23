class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https:www.perl.org"
  url "https:www.cpan.orgsrc5.0perl-5.40.0.tar.xz"
  sha256 "d5325300ad267624cb0b7d512cfdfcd74fa7fe00c455c5b51a6bd53e5e199ef9"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https:github.comperlperl5.git", branch: "blead"

  livecheck do
    url "https:www.cpan.orgsrc"
    regex(href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "af1f2117729613b32d9c6bb4269a14022fdc51ceab4bd76da9452e9d39577283"
    sha256 arm64_sonoma:  "668e1b34a46982e4a0712fcdf7f73fd1fbce74efd52dea9c7fb1ab30dda415bd"
    sha256 arm64_ventura: "37d29cde5809f66afee15192d8a59b20a9304b22ba4c100a7bf9b5d58947d3a6"
    sha256 sonoma:        "ce1b7ee92c9e17d49181e89b280ab20bb529edda5c0e82610a6fec80390a3a8b"
    sha256 ventura:       "223dd89f9b872b018434c7ce67dfda7cbb2874c7ecb13074b7b49c5fa9d92ab4"
    sha256 x86_64_linux:  "6ea16b075cfcbb386ebfbf9da400092e953df71b0743c323b4a7ca8e3db3c50d"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "gdbm"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"

  # Prevent site_perl directories from being removed
  skip_clean "libperl5site_perl"

  def install
    args = %W[
      -des
      -Dinstallstyle=libperl5
      -Dinstallprefix=#{prefix}
      -Dprefix=#{opt_prefix}
      -Dprivlib=#{opt_lib}perl5#{version.major_minor}
      -Dsitelib=#{opt_lib}perl5site_perl#{version.major_minor}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}libperl5site_perl#{version.major_minor}
      -Dperlpath=#{opt_bin}perl
      -Dstartperl=#!#{opt_bin}perl
      -Dman1dir=#{opt_share}manman1
      -Dman3dir=#{opt_share}manman3
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    args << "-Dusedevel" if build.head?

    system ".Configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    if OS.linux?
      perl_archlib = Utils.safe_popen_read(bin"perl", "-MConfig", "-e", "print $Config{archlib}")
      perl_core = Pathname.new(perl_archlib)"CORE"
      if File.readlines("#{perl_core}perl.h").grep(include <xlocale.h>).any? &&
         (OS::Linux::Glibc.system_version >= "2.26" ||
         (Formula["glibc"].any_version_installed? && Formula["glibc"].version >= "2.26"))
        # Glibc does not provide the xlocale.h file since version 2.26
        # Patch the perl.h file to be able to use perl on newer versions.
        # locale.h includes xlocale.h if the latter one exists
        inreplace "#{perl_core}perl.h", "include <xlocale.h>", "include <locale.h>"
      end
    end
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOMEperl5" cpan local::lib
      And add the following to your shell profile e.g. ~.profile or ~.zshrc
        eval "$(perl -I$HOMEperl5libperl5 -Mlocal::lib=$HOMEperl5)"
    EOS
  end

  test do
    (testpath"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system bin"perl", "test.pl"
  end
end