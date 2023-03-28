# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://ghproxy.com/https://github.com/djcb/mu/releases/download/v1.10.0/mu-1.10.0.tar.xz"
  sha256 "7f0821c7c8f22a714f3da618853e8dc2c311a6ba808d57a23ef31cbaafefac3a"
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
    sha256 arm64_ventura:  "dfce2cb7d50ea2ed47dca9333a48c906c6129d6ef2e996c9e964282956e88d78"
    sha256 arm64_monterey: "5007d0871948c375195987e10759b840467fb950fcddd19431bd82a1f42ac629"
    sha256 arm64_big_sur:  "56ff773735c87ceebdf5b8bd4dfa1ad3e3e4fd9847e16a6204a3529fbcf8829c"
    sha256 ventura:        "fcd166da00b09f5f9085db4323801b0c33dd4c5560fbeeb66b82d1d9a96ef696"
    sha256 monterey:       "023e2530601b8d31a00a8d6941b0c4b4fe2ac573fbfaa7c363a7f5d7cf34148b"
    sha256 big_sur:        "840191448b9f80b047b72c123ab7079ec8b47f4442247ee95de0c28d8dfc8e74"
    sha256 x86_64_linux:   "84ec9f19fe88f8ef4bd9e446e5e1e62e2358bcd65365ea12bc55105b04577996"
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