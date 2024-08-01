class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https:github.comcracklibcracklib"
  license "LGPL-2.1-only"
  head "https:github.comcracklibcracklib.git", branch: "main"

  stable do
    url "https:github.comcracklibcracklibreleasesdownloadv2.10.1cracklib-2.10.1.tar.bz2"
    sha256 "102ffe74865152a7ce03b5122135ac896b06cfb06684983abe3179e468787a51"

    # Fix missing endian-related functions when building on macOS (from https:github.comcracklibcracklibpull97)
    # Changes included upstream, remove on 2.10.2 or newer
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches3bd3ae1a12ffc359a7250dc4d7aeda0029f792e5cracklib2.10.1-endian.patch"
      sha256 "965c6ec5d9119c56cf2e07af8a67fb4e2e4dafc577c1a4933976e18bb81e94b8"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "0f231f48c8024fbf45ae1b8a15964bf1800388a38c6c531b63186ff70703252c"
    sha256 arm64_ventura:  "e7d7c13b6c64b85343bb3a63e8d4f36bc73558b6c71d9a3a9c0a2d7a985690af"
    sha256 arm64_monterey: "17727e4efe900789f4d4a2cf6a5be19c7a4cc96a2cde1153b95c454b0c8a936e"
    sha256 sonoma:         "597400935abe1f841d1208c22bfc36e2f2f6e851b5af57c00c4c7c7e8eca4c50"
    sha256 ventura:        "95547fe0db7ff728800cd10e1ced9534505bfdf11a3e9243f62c50b0b0abbf1f"
    sha256 monterey:       "a5869de4d658a2da346aa9ebdc1a2a389bda5a1415ae66a850b3dc174b0273de"
    sha256 x86_64_linux:   "95dfd460b7aa55d174a75a0248814ccca7770314b012368840790220b74ca9d9"
  end

  # Patch touches Makefile.am, autotools is needed to run autoreconf before build
  # At 2.10.2 or newer, autotools is only needed for HEAD builds
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gettext"

  uses_from_macos "zlib"

  resource "cracklib-words" do
    url "https:github.comcracklibcracklibreleasesdownloadv2.10.1cracklib-words-2.10.1.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  def install
    # At 2.10.2 or newer, all source code (including autotools files) are in src subdirectory
    # (replace with a `cd do` block when possible)
    Dir.chdir "src" if build.head?

    # At 2.10.2 or newer, autoreconf is only needed for HEAD builds
    system "autoreconf", "--force", "--install", "--verbose"

    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}cracklibcracklib-words"
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