class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https:github.comgnusteplibs-base"
  url "https:github.comgnusteplibs-basereleasesdownloadbase-1_30_0gnustep-base-1.30.0.tar.gz"
  sha256 "00b5bc4179045b581f9f9dc3751b800c07a5d204682e3e0eddd8b5e5dee51faa"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(^\D*?(\d+(?:[._]\d+)+)$i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6779e9ab227fc0a4263a177698054336437ea08f985c3605aed692361e5bce1"
    sha256 cellar: :any,                 arm64_sonoma:  "2d3546948a52c7946960bc75fe46a14c0cfef1eb6382e7059bde3abc6289b331"
    sha256 cellar: :any,                 arm64_ventura: "323d0c1ec262b559b455d4cb6b25a637f60768716b5982e1fd1d65ba047476c5"
    sha256 cellar: :any,                 sonoma:        "b00d56e75fba957c5fb343384b214e345bd38e307da422d136351ff73496b1e7"
    sha256 cellar: :any,                 ventura:       "4c41b940447d94a2cbbe1a67eb838f4a99b6d20547f0574b87d5030d1fb79a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9528f61500db30bc0eb553baa434d504b624406cf0da2090d8070d532cab339c"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "icu4c", since: :monterey
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libobjc2"
    depends_on "zstd"
    fails_with :gcc
  end

  # fix incompatible pointer error, upstream pr ref, https:github.comgnusteplibs-basepull414
  patch do
    url "https:github.comgnusteplibs-basecommit2b2dc3da7148fa6e01049aae89d3e456b5cc618f.patch?full_index=1"
    sha256 "680a1911a7a600eca09ec25b2f5df82814652af2c345d48a8e5ef23959636fe6"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix"LibraryGNUstepMakefiles"
    else
      Formula["gnustep-make"].share"GNUstepMakefiles"
    end

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}usrinclude"
      ENV["ICU_LIBS"] = "-L#{sdk}usrlib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share"GNUstepMakefiles"

    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.<text>
      <test>
    EOS

    assert_match "Validation failed: no DTD found", shell_output("#{bin}xmlparse test.xml 2>&1")
  end
end