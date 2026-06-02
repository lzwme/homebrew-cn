class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2026.06.01.zip"
  sha256 "fd6097aa758818a1d786ba51475fb0cdbe4ec0a0a0321730206046dd6a0a99ef"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fd84fff250c25e5152115fdeaac97426fc0825e88deb79cc5537048dd90b273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb82ad704bdcf8beb042258317ad60121de6fc84a2df22cc003559253f990ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14898746351c37c7c852f6734fb15f94fd39a4f11d0e88423566eb1297df2fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "873aed02cfdbbfd216988126a4eaddd91ac89c522fe0fff58eaa09aaf8fb5aab"
    sha256 cellar: :any,                 arm64_linux:   "e0eb0d57541afd5ca496f5c4ec72d39daec88d77496dbb2c088952172a720af8"
    sha256 cellar: :any,                 x86_64_linux:  "9a7f2b7ded54f642f6ace343cfe92fdf9566f4f6d25f350d0abd46f857c65d27"
  end

  def install
    # Work around incompatible function pointer types with newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system bin/"abc2midi", testpath/"balk.abc"
  end
end