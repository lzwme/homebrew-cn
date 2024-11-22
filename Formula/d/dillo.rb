class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https:dillo-browser.github.io"
  url "https:github.comdillo-browserdilloreleasesdownloadv3.1.1dillo-3.1.1.tar.bz2"
  sha256 "5b85adc2315cff1f6cc29c4fa7e285a964cc3adb7b4cd652349c178292a4fb9e"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "9404791603f2b7fb3fa522b7382a6475a9b4f3ac1c0809c06be4d14b5eddc803"
    sha256 arm64_sonoma:  "2f2b0384243aee474b744a136185f68e0b6f6cb3b2ca6e6e49fde33c67f330d1"
    sha256 arm64_ventura: "e9534a6faf1057a15b0b202bbab10f111f42cc7549d373fe3206a7294b9ee6f8"
    sha256 sonoma:        "5d792e66046032a6de934308c3c89ce1deb2860512bd407702de54dcbbac2142"
    sha256 ventura:       "173dc719442af8f2cd07d93eebe073e1c763650d7fde7d6768687ec4fc893f39"
    sha256 x86_64_linux:  "ad5c0fc67498f19b19ee7c216cd925b2766c706fe603340ffdc3e4542800a3be"
  end

  head do
    url "https:github.comdillo-browserdillo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # TODO: Switch to unversioned `fltk` when possible.
  # https:github.comdillo-browserdilloissues246
  depends_on "fltk@1.3"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system ".autogen.sh"
    end

    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    test_file = testpath"test.html"
    (testpath"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest<title>
        <head>
        <body>
            <h1>test<h1>
        <body>
      <html>
    HTML

    # create bunch of dillo resource files
    (testpath".dillo").mkpath
    (testpath".dillodillorc").write ""
    (testpath".dillokeysrc").write ""
    (testpath".dillodomainrc").write ""
    (testpath".dillohsts_preload").write ""

    begin
      PTY.spawn(bin"dillo", test_file) do |_r, _w, pid|
        sleep 15
        Process.kill("TERM", pid)
      end
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end

    assert_match "DEFAULT DENY", (testpath".dillocookiesrc").read

    assert_match "Dillo version #{version}", shell_output("#{bin}dillo --version")
  end
end