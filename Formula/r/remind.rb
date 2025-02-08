class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.01.tar.gz"
  sha256 "cf4a9b8fa61c923986ee5f89f73353ed087ccbc5a46fbc54378f4b733bbed493"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "9cafe0e92b185cfbcf1150cb50e95036e553303ac0099e0fae1ffdff071b73d0"
    sha256 arm64_sonoma:  "d04c1889428ceb077ea85711d3b4156b2bfa08b019c4649c73c6ae416170c33f"
    sha256 arm64_ventura: "6d1da4e4021641314ffd6797b911143937a0029485dc08f420afb2486b398cfa"
    sha256 sonoma:        "922f12b8ba8a7be36a864f0a01506d1a5ac5622c15601250869f9cafea6172d3"
    sha256 ventura:       "ae37c124e6be80093c2cff91cccfc96220f2ccae316eba7803e0664ffc0fa9f0"
    sha256 x86_64_linux:  "41b1c55ad32b4c2c1c63be9679a048cabb76bc2818eb8111016922333fb538c8"
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