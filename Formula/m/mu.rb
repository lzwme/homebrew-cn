# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https:github.comdjcbmucommit23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https:www.djcbsoftware.nlcodemu"
  url "https:github.comdjcbmureleasesdownloadv1.12.0mu-1.12.0.tar.xz"
  sha256 "55072bea9fe378c14728bd0c0d199f6ed62847b0031bd908eb277c6d3621e7cd"
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
    sha256 cellar: :any, arm64_sonoma:   "d9f806a1de64a566ebf7a45e4f4e10aee8434a89c87742554bdaf50751c891e2"
    sha256 cellar: :any, arm64_ventura:  "ebfcde4187faaa604a4c2f5afa5477c43dac72669ee67340be0bf1bfdc64e5d5"
    sha256 cellar: :any, arm64_monterey: "d347b9dff69e80fb529aafb3432f3b2c31e4a87b28be67d16e1dc78b803c81c8"
    sha256 cellar: :any, sonoma:         "71217ce260e187ec3da1d286bc1d8580b299330b304cf2f9461dc83f54831823"
    sha256 cellar: :any, ventura:        "d98df3e231cca3339410b2fe70b6f7d92390d2d941a1130bedc842e32d4c3b5e"
    sha256 cellar: :any, monterey:       "07fea4876e01a4fa86127d10b632fecc79c126a5e95fa4c04c8effbca17f5ed6"
    sha256               x86_64_linux:   "b24668b38b88c124abaa7a1652ac0af885e24e514c22e97a65286a04bd3027cb"
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