class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_3_0.tar.gz"
  sha256 "ef5d2a9322c6350c560fb2299978654177c96e8dde8f878bb5799c6f10216638"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7b7acc9789753e9f5fa7ffea6d9e13e54bf4cf4f5bc4950d6f8ee9671b373d7"
    sha256 cellar: :any,                 arm64_sonoma:  "6d862a6b2a3aef6b4bf8485e4bb54767533c4ecfae37f38eaddd3e0c2c9182d2"
    sha256 cellar: :any,                 arm64_ventura: "ae83f8265adb128a9643f2dd29963754ec7b2a7bdd0f87b80e0e56fbb73f4ee3"
    sha256 cellar: :any,                 sonoma:        "f8b70b9dabf8d0480cdb1e071f89a8bfb302394fbe0107e2559c1cc946e311fb"
    sha256 cellar: :any,                 ventura:       "a4edec1d894b754b902d6512bae4589a34ede83336ba35592c50a883956f5379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cfee9ddd75de30f9ba88280fbdcea20c8cc8dcf4f59b01a4a664667903af8c"
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