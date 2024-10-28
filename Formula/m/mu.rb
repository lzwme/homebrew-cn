# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https:github.comdjcbmucommit23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https:www.djcbsoftware.nlcodemu"
  url "https:github.comdjcbmureleasesdownloadv1.12.7mu-1.12.7.tar.xz"
  sha256 "d916ba9b8ada90996b37eedf7f5fc70c35eb77f47fd933a502fbe0dccf2a6529"
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
    sha256 cellar: :any, arm64_sequoia: "b6a33fa31f3573014104a07185888b360edd54b6b53ed1787f8f5c53638146ac"
    sha256 cellar: :any, arm64_sonoma:  "02a8fabc201b66024940d4b3f4bd37478d0ee5c3555c1c5cab2487f2f2dac363"
    sha256 cellar: :any, arm64_ventura: "f7066054702fa006ff01baa15f7db74c31e68ed0214adf9685130633288191fb"
    sha256 cellar: :any, sonoma:        "a740ad58e95867017d049e98f5592f4a119cbaf8a222bf8a923372a26531bd91"
    sha256 cellar: :any, ventura:       "7a340cd2dc7302b87806544dd67ee2a4adb39e61b4d2fd6aa299f2f5a4901864"
    sha256               x86_64_linux:  "45f957add52e578e5f6c3bedf66d0116ceb27472c1beba965badf64095920b00"
  end

  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with gcc: "5"

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

    system bin"mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system bin"mu", "index", "--muhome=#{testpath}"

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