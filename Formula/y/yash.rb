class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https:magicant.github.ioyash"
  url "https:github.commagicantyashreleasesdownload2.58yash-2.58.tar.xz"
  sha256 "1a027496a6b8d2aa946d0b13407fdc3d5030f1d17f09b27768967c50f09e61f0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "f4a1e437588a3869754db712725f5b5999adbe9e685e96d1787113ce155d1772"
    sha256 arm64_sonoma:  "9f30f9a1719517b0448995a405203af2445fe7960a6d7ad8241b8818ade92318"
    sha256 arm64_ventura: "b5dfc5d6a7347c08b83e689c13fd1ae176b81e52ba1bb937f338498b67e7d44b"
    sha256 sonoma:        "32fe163eb32a170b4fd91b4b0c6de34901e0e9a7e02147958ff65c2c4d1e71a8"
    sha256 ventura:       "a55452974b871a1e6b0987ff1e9bc1465507e59f97356bcc5c72faac307b5184"
    sha256 x86_64_linux:  "329a269ab05fb80643308a5c0d39dd388fc4434c2be37da9274857b8a94ddccc"
  end

  head do
    url "https:github.commagicantyash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog" if build.head?

    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin"yash", "-c", "echo hello world"
    assert_match version.to_s, shell_output("#{bin}yash --version")
  end
end