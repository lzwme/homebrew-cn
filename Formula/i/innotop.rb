class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https:github.cominnotopinnotop"
  url "https:github.cominnotopinnotoparchiverefstagsv1.15.2.tar.gz"
  sha256 "cfedf31ba5617a5d53ff0fedc86a8578f805093705a5e96a5571d86f2d8457c0"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https:github.cominnotopinnotop.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b712a7c6581579deb190f4ee7e259fd1d8d86a3eafcc0c6a995e1fa71782c5be"
    sha256 cellar: :any,                 arm64_sonoma:  "b6fee84229d2f0a4484314b92acdd6b4750d7568e8d0828f1b45a71084514a9a"
    sha256 cellar: :any,                 arm64_ventura: "ee625d9158716ac21cf295436c730adb65e90dae4ac01eac072318b114734739"
    sha256 cellar: :any,                 sonoma:        "d66f285ed55e8b517d496ff3f823872e9ceea88145d255e44048a10a631f27c3"
    sha256 cellar: :any,                 ventura:       "ba40a81476e96be812e92c8637717511e2051b5c97c0e1149bc29951a32b033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa30fc17b6d41c74eeb3391afb5110b5675d61bcdf27ab8e66edb318c858c57"
  end

  depends_on "mysql-client"

  uses_from_macos "perl"

  resource "Devel::CheckLib" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTNDevel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    on_linux do
      url "https:cpan.metacpan.orgauthorsidHHMHMBRANDDBI-1.646.tar.gz"
      sha256 "53ab32ac8c30295a776dde658df22be760936cdca5a3c003a23bda6d829fa184"
    end
  end

  resource "DBD::mysql" do
    url "https:cpan.metacpan.orgauthorsidDDVDVEEDENDBD-mysql-5.011.tar.gz"
    sha256 "a3a70873ed965b172bff298f285f5d9bbffdcceba73d229b772b4d8b1b3992a1"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https:cpan.metacpan.orgauthorsidJJSJSTOWETermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath"build_depslibperl5"
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    resources.each do |r|
      r.stage do
        install_base = (r.name == "Devel::CheckLib") ? buildpath"build_deps" : libexec

        # Skip installing man pages for libexec perl modules to reduce disk usage
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"

        make_args = []
        if OS.mac? && r.name == "DBD::mysql"
          # Reduce overlinking on macOS
          make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs"
          # Work around macOS DBI generating broken Makefile
          inreplace "Makefile" do |s|
            old_dbi_instarch_dir = s.get_make_var("DBI_INSTARCH_DIR")
            new_dbi_instarch_dir = "#{MacOS.sdk_path_if_needed}#{old_dbi_instarch_dir}"
            s.change_make_var! "DBI_INSTARCH_DIR", new_dbi_instarch_dir
            s.gsub! " #{old_dbi_instarch_dir}Driver_xst.h", " #{new_dbi_instarch_dir}Driver_xst.h"
          end
        end

        system "make", "install", *make_args
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec"bin", PERL5LIB: libexec"libperl5")
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}innotop --version")
  end
end