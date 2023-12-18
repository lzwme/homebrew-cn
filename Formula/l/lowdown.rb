class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https:kristaps.bsd.lvlowdown"
  url "https:github.comkristapsdzlowdownarchiverefstagsVERSION_1_1_0.tar.gz"
  sha256 "5cc997f742fd9e3268a2bf15cb9c58bfa173b303bc13f5c61f67dedfff3bccce"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "255c337ab676dffb3ef9b340b4d068e24b6b872f0f8c7f8f97849ce75ca8a4bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f1b67c96014feb0f6491d5082d455e6d35efda11153235f9ed2e8cdc05e2b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ac7b1a9025db2dfbeab480863f5a4f078e9915825eae09443138ef5f164251"
    sha256 cellar: :any_skip_relocation, sonoma:         "17472061e49483d9c4e756a57ded3ffa838a3222ce507f78aaf28a8c0374db66"
    sha256 cellar: :any_skip_relocation, ventura:        "48ae3bf827b706dc7db75d2203a636eb6bbdfd7a6172a7c851a34db93c67629b"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6ec656e57b50f3b7486fd31bd08f5b227b7eb4c11c18b48c2572feb705510d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f28e7aa9a05b850a201e2c9869d0f970314ca095b0d72a1f32c3fb95502e8c0"
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
    system "make", "install"
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