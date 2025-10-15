class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"
  license "GPL-2.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "01413047be89a3e516a5a8e4668488ae73c1b30e90d98ed6e4c47d43e4672a46"
  end

  depends_on "docbook2x" => :build
  # Do not bump, `FancyURLopener` is removed in 3.14
  # ref: https://docs.python.org/ko/dev/whatsnew/3.14.html#id12
  depends_on "python@3.13"

  # Remove for next release
  patch do
    url "https://github.com/lubuntu-team/pastebinit/commit/ab05aa431a6bf76b28586ad97c98069b8de5e46a.patch?full_index=1"
    sha256 "1abd0ec274cf0952a371e6738fcd3ece67bb9a4dd52f997296cd107f035f5690"
  end

  def install
    inreplace "pastebinit" do |s|
      s.gsub! "/usr/bin/python3", which("python3.13")
      s.gsub! "/usr/local/etc/pastebin.d", etc/"pastebin.d"
    end

    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    etc.install "pastebin.d"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install %w[po utils]
  end

  test do
    url = pipe_output("#{bin}/pastebinit -a test -b paste.ubuntu.com", "Hello, world!").chomp
    assert_match "://paste.ubuntu.com/", url
  end
end