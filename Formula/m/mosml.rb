class Mosml < Formula
  desc "Moscow ML"
  homepage "https:mosml.org"
  url "https:github.comkflmosmlarchiverefstagsver-2.10.1.tar.gz"
  sha256 "fed5393668b88d69475b070999b1fd34e902591345de7f09b236824b92e4a78f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4c5e5c68a5bafb747f9bf0ebf55e7e67f6ff97ad8107a788579db55b27a5a1c9"
    sha256 cellar: :any,                 arm64_sonoma:   "baf1606f54aca14fe0f9a0e734cea0518dc817fd42fb0b755364da0fa3362e9e"
    sha256 cellar: :any,                 arm64_ventura:  "697eb51321f126674f814f5cca5c08956104eb3d4181c04aa055afbf779f068e"
    sha256 cellar: :any,                 arm64_monterey: "0bcc8223cece7f0320b69b009eda89cda3cec9fc8e10877fbd985eea878cb345"
    sha256                               arm64_big_sur:  "0163ff06ef4997b1ab8eb1e55463475fc78f89ad4dd795d7ff4caeaca932a901"
    sha256 cellar: :any,                 sonoma:         "4a3c5631a1b2156bfc5b890dfcbcca3c131f0f823834b9d6e50b8ce83d3d0e2b"
    sha256 cellar: :any,                 ventura:        "d416c4d3d7861b6b964aefd53dbb97a2778f111245dabb69b8c3e9bf2933c612"
    sha256 cellar: :any,                 monterey:       "c0cf01f015c8ea1da6bca0a1a64567fc3535f746bb2a3f07002f3a56f1371234"
    sha256                               big_sur:        "96fae7154e49e57180eee17d8d90580a0e2d024f2f0b7510cfcc83d59f0449be"
    sha256                               catalina:       "d39293549810bf64ade65bcbcb969abf1c76d0812c2d9e8c2ffd8329d2d2a34b"
    sha256                               mojave:         "f1a7484f284f194ece9c3bc25a99b8f38312ff504b207a57337b7de7f4e46755"
    sha256                               high_sierra:    "7a888abd233069f837cf9aba4021baa71387a4b720bc53323d40a963433b566a"
    sha256                               sierra:         "297c05c55f2784f3b934a2fdb3ec2f91d8b11a06453c8649c1f6562cefdc089e"
    sha256                               el_capitan:     "5dae62ca2034ba70844d684111cec58561895eac39db3177d439747512206002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42bf79793655431b313d4c547e7c9b6867b2f1695035005a15b8da6c0b25c416"
  end

  depends_on "gmp"

  # Backport missing headers to fix build
  patch do
    url "https:github.comkflmosmlcommit52b00ca99dcd77d64dac5a7600fe64a76ed1ac3a.patch?full_index=1"
    sha256 "e0db36e944b5d60e0e98afd3f3e9463d193ae89b7aa66d2cc7c452c6c6ed8632"
  end

  def install
    # Work around for newer Clang
    ENV.append "CC", "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "make", "-C", "src", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "world"
    system "make", "-C", "src", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    require "pty"

    _, w, = PTY.spawn bin"mosml"
    w.write "quit();\n"

    assert_equal "I don't know what to do with file \"foo\", ignored", shell_output("#{bin}mosmlc foo 2>&1").strip
  end
end