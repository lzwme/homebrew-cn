class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https:github.comTitor8115mandown"
  url "https:github.comTitor8115mandownarchiverefstagsv1.0.5.1.tar.gz"
  sha256 "44cfd210cb12051ceb5ea53d902f8190dbdb802c97608297c37c4efbd102d489"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d1116264c89f5e6f91d55fb6e7cc6245dc804911a0903a0136c5abcbce38094b"
    sha256 cellar: :any, arm64_sonoma:  "6849a425fac96c73d2a4dbd6028cf9a84633eed12a4e863077294752193d9ecf"
    sha256 cellar: :any, arm64_ventura: "63cfd069f04d06f78c7e77726d24d55d9dae8f6b135bf479fb08fc5b70564ed2"
    sha256 cellar: :any, sonoma:        "98b3dc3dbcbea95cd7219e2e9c17ddac7908ab2cb4c2059c6d730c8d50806119"
    sha256 cellar: :any, ventura:       "e84f21bc7098f4e67560c2ac79f9bcfb42789c204c65635694033802e2b6f2ec"
  end

  depends_on "pkgconf" => :build
  depends_on "libconfig"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PKG_CONFIG=pkg-config"
  end

  test do
    (testpath".configmdn").mkpath # `mdn` may misbehave when its config directory is missing.
    (testpath"test.md").write <<~MARKDOWN
      # Hi from readme file!
    MARKDOWN
    expected_output = <<~HTML
      <html><head><title>test.md(7)<title><head><body><h1>Hi from readme file!<h1>
      <body><html>
    HTML
    system bin"mdn", "-f", "test.md", "-o", "test"
    assert_equal expected_output, File.read("test")
  end
end