class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.04.tar.gz"
  sha256 "63070642f7f123846f26d66db3b07abdd4ae359878e6d9bbefae130c9fb4c91c"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "be33e8e3942c1c2374658574d8638542c6a57ad76f16a516c35f489c4a46885b"
    sha256 arm64_sonoma:  "2222f83345c80d6141bff980029f6143db3498f2dc4145be51145123cfb00638"
    sha256 arm64_ventura: "ec6fe533bd3946608f26bc20deea6f94dbc19f64163c0ccd3b23e140290316cb"
    sha256 sonoma:        "8befcf3aae83d65211cc5bba1878bfa110ae6bfbdc0fdab0eaf67d15d97075ce"
    sha256 ventura:       "e09c71bd15a0add123fdd0471ea3ab2c938f4db98f354677ae16024aaa435b5c"
    sha256 arm64_linux:   "a437d7244c3aa9e6cdefd444e66990b52da16d773841dca0865e3b0d35e40038"
    sha256 x86_64_linux:  "07044ddeb712cab031f1d1c738139bfada0be99083294850df6a87f833042efa"
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