class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.02.00.tar.gz"
  sha256 "916145b573a83505decaf7571aee660102b0b9c52b89886bffea9d81e82ebdd6"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "76c650aff584a3c4fb743495318c1b62b97060069efdaac26a965e7a9ad5667d"
    sha256 arm64_sonoma:  "287b41ca8169e7053d27fb82be9f24eb43546788f216c0f2066e60c939a5240b"
    sha256 arm64_ventura: "0276bd5da105ef9b969c89c8a5d2feb3c4f216a9c123949491ad7d146d501dd7"
    sha256 sonoma:        "20ebaa31095140e7b9855314de19aebb1f40da36cab3e8cbce3d994700805321"
    sha256 ventura:       "19acabe191c1b37b842a6214a61c012e17c4091d97464dca275bfdfc4f1051e5"
    sha256 x86_64_linux:  "88a4546f3279a8ce7cf9aea3effea4d0f51e9a8142ab972aeaf9475fe78320db"
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