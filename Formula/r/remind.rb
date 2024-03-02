class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.01.tar.gz"
  sha256 "b619a370d59ad6de2c1d04d4bba368b5b4e14c9eac72aaddfd4581a842ded4d3"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "4caf7a997746b2c63668dae6506869320675212b876424e6842fba56957a0cd3"
    sha256 arm64_ventura:  "f74ea978d9f0fdfe774871736c1930a5e5f5c84a1d508ea77c894ce4c966065d"
    sha256 arm64_monterey: "99af6236a4e93ee10546602e144ca5007036538e9aafcaeda218f4d853d09ab1"
    sha256 sonoma:         "171b608e9fcfd69689aa84b0cc27e2e82c57bf24166ff0e1ada06b724dafcf17"
    sha256 ventura:        "545989bc97f12f9aa8b5bf2ca98d30c53e1c75ec79907fe732b30c4773ef6f6a"
    sha256 monterey:       "09ac4a19ca53cc1d50de3de2ace4ed22e29bf8607be1920ca46e48219b008b5e"
    sha256 x86_64_linux:   "240322ccc4b3e553e33a75982024eb497a14bb4032afe9fb2d9dcfc457b34cc6"
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