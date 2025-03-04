class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.03.tar.gz"
  sha256 "9293d9a7f398098cdfcaed984be94c4be64197a9fc8d7581dd8bb0d50ff81a71"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "fa7111360e5d300b339ae4b00db62ec8a625ecfa1be9c5410bfd98ce2d9e8687"
    sha256 arm64_sonoma:  "790ea1649b7c67a80b494a5786814f5fcc0a7a6be0cee19fe9156d3eef521011"
    sha256 arm64_ventura: "bce14a1a0dc162551768c470a068a8ef08f6bee0b400c340dec384c740ccf77e"
    sha256 sonoma:        "38514c89208426d8d28bd1296d9e46890ddc2e008e6da24fdbb540f4a345e14a"
    sha256 ventura:       "dbc1767528487cdde2e83554f9c83279df70671c8c4ae7883b0d0927243749b5"
    sha256 x86_64_linux:  "4d65b22cfd7ba0a08aa5f184a18237df8b5d89950ff5e3ee9af0a0f0ddf3fa05"
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