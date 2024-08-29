class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.03.tar.gz"
  sha256 "f64b9173f625164f4352d9bb24bb79116b4168f63a2cc243e14e43447e30ea62"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "cb3b18bccf901b7206bfecfafa8a4be5a814244ec62fba87f70337ce9025f7d4"
    sha256 arm64_ventura:  "0729ab316cd50c3ea421ebb46208abf9974a7d6c440a51eac57c83687a4bf098"
    sha256 arm64_monterey: "1e40c9d9a41a4affbd9c9ea4047c425b654f0bdd315856cdc49c7e44ee022d1c"
    sha256 sonoma:         "ee6795d3da6d2a38d89141739bd7d0b8c67b2439b19d198976b4ebca0e5401d3"
    sha256 ventura:        "33b8b66896acf2858c95b8413376556eb2778301953f1cca5eb4a91bb9d3e188"
    sha256 monterey:       "eb0dc3367ab18f7994d507ded2c063dc248a3ef97f769ce9ee0efcd198bfa2bf"
    sha256 x86_64_linux:   "a34e6b4f53bbfce96f9211170034b427ae934fdcb25e44b85818ceca8bc9dc8a"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end