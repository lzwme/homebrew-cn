# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https:github.comdjcbmucommit23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https:www.djcbsoftware.nlcodemu"
  url "https:github.comdjcbmureleasesdownloadv1.12.3mu-1.12.3.tar.xz"
  sha256 "ce6edd5661ffe3de4c9e17a6c8cdaf233b3cd5e85c82ed876d87c064e6e7b7e0"
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
    sha256 cellar: :any, arm64_sonoma:   "4e2f8f1db0c88a6a83d16d6e1742426ab7b4132e3a3a6e77e4ad630fec7e2a07"
    sha256 cellar: :any, arm64_ventura:  "4f0c4135ac69d9ede92749bdbdb5137e1609a3563c51b99b82c8f7e10e9eb334"
    sha256 cellar: :any, arm64_monterey: "c9a742a395121cda6c42f48d42bca4a00c3ebbe030a62fdcda8c3a7a1974eb00"
    sha256 cellar: :any, sonoma:         "f68b69277e8e5cf8eb58d74537bc724a6a3583556ff45d1871c96c939c8bd0b6"
    sha256 cellar: :any, ventura:        "7f1d2bec30ad77e3cdb6bd50fa1f978689ec204888a87fc137b24529cd5443f6"
    sha256 cellar: :any, monterey:       "5d0b5c974de44382d5e78b3ac52b57d6bb78afea04bc7895f8ba072afe299a4a"
    sha256               x86_64_linux:   "88eb0dbbc5f2d44898e4ea309337aecf3d4a4ce56f28ad5695e0cbd0261041e0"
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