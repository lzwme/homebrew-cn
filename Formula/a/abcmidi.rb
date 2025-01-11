class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2025.01.10.zip"
  sha256 "5a19589cd5bfdcc8b6be4e0e75cf6d22e96c0d7714c2215581b94edc7bd51c48"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f9c8800584d27e0e78018f6550eaad51ca3dbd7a9bfdbea5e6cccf623b1963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521df6cd949af6524e5d0e7bbec33ba0e06058f5ff1d271b204487e997d03fac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32caa5723734f49297afdf14a499875d1278d1e67514d94ddd65a7058beb0a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "b247e65a04834d6022105c3f7cd9097c9d755d7fb2a5c9c151080cfb15ae8555"
    sha256 cellar: :any_skip_relocation, ventura:       "0a56975d4928612e101720aaf645bd1d5604c92439e9bd12e0e2be0cafbce74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92400b03b209c864e2e1076ebe6d649f47215a9afe2f01b978acfae6f868cbb"
  end

  def install
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