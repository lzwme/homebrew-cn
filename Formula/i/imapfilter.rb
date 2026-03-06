class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://ghfast.top/https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "a28ee90ac20a996e2fc19cbc36a36c152483085011f3b2ec8dfd913b7a6d9804"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "47761fad4ebad9ad9c7b5c17bd214cf02c15c18b4d1492a29847aba4c0b8e333"
    sha256 arm64_sequoia: "88707a8aef9727bb63d1120fd20a109245d94b0816afc2089792af61e60b5784"
    sha256 arm64_sonoma:  "bd25a128c213b1e367d34728410bdd8ba288f923963041218ad7e65988b8c76e"
    sha256 sonoma:        "64dd0149be56e395778e96ec0499c0f5c2d14f9d31f96149f7f64abb7c1fe2c4"
    sha256 arm64_linux:   "4d72341c4d5d36d13b7f0e79fbe1fda910b9efd35e63b857325fbd764933b765"
    sha256 x86_64_linux:  "554b1a712c5f12e863f46a6235d6a8afc58832c801de3913165271968de6652a"
  end

  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats
    <<~EOS
      You will need to create a ~/.imapfilter/config.lua file.
      Samples can be found in:
        #{prefix}/samples
    EOS
  end

  test do
    system bin/"imapfilter", "-V"
  end
end