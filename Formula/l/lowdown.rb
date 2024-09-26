class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_1_1.tar.gz"
  sha256 "8224d936507664a57845c5eb6d8a97a32cb8f85ad60fb987bebf5f1fb1bb50bd"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "083854b211698bbcbf48a181e1211864f2566da9cd1d605ca0c9d5e9f4216908"
    sha256 cellar: :any,                 arm64_sonoma:  "8140f9b8ac3fc9b2ea32b54b42f91ebb2a1b31ab0e8052681b435c3108edd824"
    sha256 cellar: :any,                 arm64_ventura: "35c2bff94a719995f126b0774bc4e4183528aaced985d24a891b0ffc71619403"
    sha256 cellar: :any,                 sonoma:        "d354342fe3746ce10846e44a41cb09981a7411a20b18f8877a2b810e67440514"
    sha256 cellar: :any,                 ventura:       "1c6b63152daa27af6e83446564eb7202c9739471555a006794afefb71363c87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d3e51550508e399228149486d2faac21a3d2771b923628b526af9a853e14d1"
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