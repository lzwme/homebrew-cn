class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_3_1.tar.gz"
  sha256 "028b77171cfa03d8360aaaaab81ef3ab1e99f9623cd39e62c5dae82ebad7c5db"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a608d381364963ab721a75f2d02e5a2c987ebc22b6069020d990c9755282afa1"
    sha256 cellar: :any,                 arm64_sonoma:  "7186f60365e88d2f8f83ce81dbc35c6a32b5947da68a18e031aa17267715f08d"
    sha256 cellar: :any,                 arm64_ventura: "a4d9c6568df45a79df945cd58552af85a52b01ae5b0dce50620d81fc2d61cf2f"
    sha256 cellar: :any,                 sonoma:        "d500f7c023996f93f75b96d09a1e12d85a8b70a08fbcfe22d73a884fb1f94468"
    sha256 cellar: :any,                 ventura:       "0f420224179cd4969433cfdd1d017c3f24666db599b6a7713c65ac1246b1da17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fba34df1d8206032d8bacb33d6226d6d50a184eb27591e27f76b10a6ea994c70"
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