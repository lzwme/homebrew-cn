class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_2_0.tar.gz"
  sha256 "a4a7eab951b85a8b25c806a4e399ef3e06458a3f6811ac1201a5fb765ccde3d2"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bd6fdbbe532d6d433c7b15771a3175708f4e9652491cedba222d03e67b5ff5f"
    sha256 cellar: :any,                 arm64_sonoma:  "9fd15db78f4fb5365369713c732a31d674be049f211dd494b775087702a3a478"
    sha256 cellar: :any,                 arm64_ventura: "5260cbdf7b10460160cb39beda9f124a2769d54f17d13c449e59db9cd78e129d"
    sha256 cellar: :any,                 sonoma:        "2f3f2cb3dcb4706b5c91d6039fc732e3923cce0fecc14719d2f80c573a5ded33"
    sha256 cellar: :any,                 ventura:       "5c324d03e446de5591fe02650d21149c887d388f9e18ef96563076616a6bec37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c77eaf34c970ddbea7326e672099cd9208b9bb0f1e0b6b72192a595f4e9aedf"
  end

  def install
    configure_args = %W[MANDIR=#{man} PREFIX=#{prefix}]
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      configure_args << "LINKER_SONAME=-install_name"
    end

    system ".configure", *configure_args
    system "make"
    system "make", "install", "install_libs"
  end

  test do
    expected_html = <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8" >
      <meta name="viewport" content="width=device-width,initial-scale=1" >
      <title><title>
      <head>
      <body>
      <h1 id="title">Title<h1>
      <p>Hello, World<p>
      <body>
      <html>
    EOS
    markdown = <<~EOS
      # Title

      Hello, World
    EOS
    html = pipe_output("#{bin}lowdown -s", markdown)
    assert_equal expected_html, html
  end
end