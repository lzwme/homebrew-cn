class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https:github.comgnusteplibs-base"
  url "https:github.comgnusteplibs-basereleasesdownloadbase-1_31_1gnustep-base-1.31.1.tar.gz"
  sha256 "e7546f1c978a7c75b676953a360194a61e921cb45a4804497b4f346a460545cd"
  license "GPL-2.0-or-later"

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
    sha256 cellar: :any,                 arm64_sequoia: "ede50b79bcb8a6c0a47339bfcdf39f048962d1514015c5cbdd6c9a4760aee69b"
    sha256 cellar: :any,                 arm64_sonoma:  "3b2e44ee9247c8d63b84912e4a4726820d5d8bc9092ae5566853d9b119aada50"
    sha256 cellar: :any,                 arm64_ventura: "f218b318c4b8835c31c1bcb6eeac58cdfa0894a2021d7e26c1cdf5bdce6a80f2"
    sha256 cellar: :any,                 sonoma:        "812aa8fae123bd2799b8b1841d4b01bcff9b2b8e25f9b897659d89d962c28420"
    sha256 cellar: :any,                 ventura:       "fe4f0cc328ef0dc600196af6c7b1796bf4b7f2a05f0ff418b63f723c8a08be9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a906c5120ed08dc88fe2de568fbd905cf90beedc1151c5f1d2238a6a0b4b46d0"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_system :linux, macos: :big_sur_or_older do
    depends_on "icu4c@76"
  end

  on_linux do
    depends_on "libobjc2"
    depends_on "zstd"
    fails_with :gcc
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix"LibraryGNUstepMakefiles"
    else
      Formula["gnustep-make"].share"GNUstepMakefiles"
    end

    if OS.mac? && MacOS.version > :big_sur && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}usrinclude"
      ENV["ICU_LIBS"] = "-L#{sdk}usrlib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share"GNUstepMakefiles"

    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.<text>
      <test>
    XML

    assert_match "Validation failed: no DTD found", shell_output("#{bin}xmlparse test.xml 2>&1")
  end
end