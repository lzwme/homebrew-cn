# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://ghproxy.com/https://github.com/djcb/mu/releases/download/v1.10.1/mu-1.10.1.tar.xz"
  sha256 "00cba4b6a54151de8f3fb06d4d6a180cd20e0f1780cec751890c647ae60e944f"
  license "GPL-3.0-or-later"
  head "https://github.com/djcb/mu.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e9f196c648ef03b08526926b5d8c11db4bc599df5dd049580273154f7095cad3"
    sha256 arm64_monterey: "76dc383f291dc415738c8d7a87a5994a8cd524c046876af39a950f5058c4f32a"
    sha256 arm64_big_sur:  "6080d014d7f8a6428cb39c75a62dd5c4da79b063e997b49b600ad5609aabfc67"
    sha256 ventura:        "64aa46d6121c9f34644b457d8edaf1983ef458f546f2a504f2c1d5b957dbbd8d"
    sha256 monterey:       "f75c11690784eae137ff211b12bb3e78db3c8076af636926d07da85cdbe47733"
    sha256 big_sur:        "0b1bf1e2f42da1489844501eaaf3de6a02bd390201e9d4bfe01bd33b3126e2ea"
    sha256 x86_64_linux:   "73b4b88d2e0404d6a234ad27ff039e4e78fd8b4a10bc61a59dd2b3426a40b64c"
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

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dlispdir=#{elisp}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    mkdir (testpath/"cur")

    (testpath/"cur/1234567890.11111_1.host1!2,S").write <<~EOS
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath/"cur/0987654321.22222_2.host2!2,S").write <<~EOS
      From: "Wile E. Coyote" <wile@example.com>
      To: "Road Runner" <fasterthanyou@example.com>
      Date: Mon, 4 Aug 2008 12:40:49 +0200
      Message-id: <2222222222@example.com>
      References: <1111111111@example.com>

      This used to happen outdoors. It was more fun then.
    EOS

    system "#{bin}/mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system "#{bin}/mu", "index", "--muhome=#{testpath}"

    mu_find = "#{bin}/mu find --muhome=#{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count, <<~EOS
      You tripped over djcb/mu#380
        --related doesn't work. Everything else should
    EOS
  end
end