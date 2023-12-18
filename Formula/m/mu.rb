# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https:github.comdjcbmucommit23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https:www.djcbsoftware.nlcodemu"
  url "https:github.comdjcbmureleasesdownloadv1.10.8mu-1.10.8.tar.xz"
  sha256 "6b11d8add2a7eeb0ebc4a5c7a6b9a9b3e1be8c5175c0c1c019a7ad8d7e363589"
  license "GPL-3.0-or-later"
  head "https:github.comdjcbmu.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https:github.comdjcbmucommit23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
  livecheck do
    url :stable
    regex(^v?(\d+\.\d*[02468](?:\.\d+)*)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "f914713faba9d8ec5e429b1db28635228eb1903150d0228f7b18f90b3711d7f7"
    sha256 arm64_ventura:  "6f59343227f8fc577bcf8fa66ef4de25091f9e505579f0fa68e119a79fc37030"
    sha256 arm64_monterey: "371e49e5d6b9b37dd8c9c75a4c80f84ce2e47c54c6f35984f5bfa87df8d6675e"
    sha256 sonoma:         "3146174126d58f9e4b1763330230987f9e449f0209d6c174bd7dfe299cff54b7"
    sha256 ventura:        "6c9a5e2688946e0120524bad0f7b3662517101d38763bce656d5e3675aec3c49"
    sha256 monterey:       "8158e3431ed0627d25e785b426a045faab3100ef518bbc589a483514ec0b9598"
    sha256 x86_64_linux:   "f59d587fb60654fd0611a7ea9f2b9cc2b91dca1b187dd76b0c89986a716fdec6"
  end

  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "guile" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "xapian"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with gcc: "5"

  # upstream bug report, https:github.comdjcbmuissues2531
  # reverts https:github.comdjcbmupull2522
  patch :DATA

  def install
    system "meson", "setup", "build", "-Dlispdir=#{elisp}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # Regression test for:
  # https:github.comdjcbmuissues397
  # https:github.comdjcbmuissues380
  # https:github.comdjcbmuissues332
  test do
    mkdir (testpath"cur")

    (testpath"cur1234567890.11111_1.host1!2,S").write <<~EOS
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath"cur0987654321.22222_2.host2!2,S").write <<~EOS
      From: "Wile E. Coyote" <wile@example.com>
      To: "Road Runner" <fasterthanyou@example.com>
      Date: Mon, 4 Aug 2008 12:40:49 +0200
      Message-id: <2222222222@example.com>
      References: <1111111111@example.com>

      This used to happen outdoors. It was more fun then.
    EOS

    system "#{bin}mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system "#{bin}mu", "index", "--muhome=#{testpath}"

    mu_find = "#{bin}mu find --muhome=#{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count, <<~EOS
      You tripped over https:github.comdjcbmuissues380
        --related doesn't work. Everything else should
    EOS
  end
end

__END__
diff --git aguilemeson.build bguilemeson.build
index 933553c..ca051d1 100644
--- aguilemeson.build
+++ bguilemeson.build
@@ -73,9 +73,7 @@ lib_guile_mu = shared_module(
   [ 'mu-guile.cc',
     'mu-guile-message.cc' ],
   dependencies: [guile_dep, glib_dep, lib_mu_dep, config_h_dep, thread_dep ],
-  install: true,
-  install_dir: guile_extension_dir
-)
+  install: true)

 if makeinfo.found()
   custom_target('mu_guile_info',