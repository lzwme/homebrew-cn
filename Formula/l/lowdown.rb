class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_3_2.tar.gz"
  sha256 "93ada3d0986536df638865d3ba249b5428d2c70153c11d683aa2b3e91c15e3d0"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "caea7a23190c194ec64a1f3b9f547a695b9fa736bcf830d66a822f40422aeb11"
    sha256 cellar: :any,                 arm64_sonoma:  "7f52f1c541875792147ab241711090e3de10d1f7cdb956fe0cd74c4042df5fc1"
    sha256 cellar: :any,                 arm64_ventura: "91057d8afc801e954cc87f52ad7f9af029d11461c80a525adc1bb4b0ac56625d"
    sha256 cellar: :any,                 sonoma:        "9a634d52da41dbe84fbe638bea0f0feebebfd6c635e513bebb0ae811d23736b0"
    sha256 cellar: :any,                 ventura:       "41f632dfbf437a8f943d6c84f2b81e7573a0ced322ad3246ac113cda7db60ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c27c8e50b9341cbc4033d4cabae95f47f72caa481e0d158b84abfd93c4e68fd"
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
    expected_html = <<~HTML
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
    HTML
    markdown = <<~MARKDOWN
      # Title

      Hello, World
    MARKDOWN
    html = pipe_output("#{bin}lowdown -s", markdown)
    assert_equal expected_html, html
  end
end