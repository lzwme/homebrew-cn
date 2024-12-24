class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https:github.comcracklibcracklib"
  url "https:github.comcracklibcracklibreleasesdownloadv2.10.3cracklib-2.10.3.tar.bz2"
  sha256 "f3dcb54725d5604523f54a137b378c0427c1a0be3e91cfb8650281a485d10dae"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "9d98bf420b98834ad967baf58c7282e2e8e280c967dd1dc8b5e7ae878fe81666"
    sha256 arm64_sonoma:  "9496d3be435158f297c9428e967289ec4fe41d442c02bf0ade3a432c91c05a36"
    sha256 arm64_ventura: "5798b58bebd1cd635c356812c0aa23c606b78395c193669efcb0bc8691b9d5b6"
    sha256 sonoma:        "106cf73076dbca2480f870e24c63057044b6c1bcebb4423ef74aae8c65dc154f"
    sha256 ventura:       "766a21b910e679477f796177b5241589b2abb2fd834bc6b32144ba7d731a8dc0"
    sha256 x86_64_linux:  "3032a4afab1d0877faa7b2e27740d11632a394b3478d5e7aeb690b6badef3cc6"
  end

  head do
    url "https:github.comcracklibcracklib.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "cracklib-words" do
    url "https:github.comcracklibcracklibreleasesdownloadv2.10.3cracklib-words-2.10.3.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  def install
    buildpath.install (buildpath"src").children if build.head?
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system ".configure", "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}cracklibcracklib-words",
                          *std_configure_args
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var"cracklib").mkpath
    cp share"cracklib-words-#{resource("cracklib-words").version}", var"cracklibcracklib-words"
    system "#{bin}cracklib-packer < #{var}cracklibcracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output(bin"cracklib-check", "password", 0)
  end
end