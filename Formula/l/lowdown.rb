class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-3.1.0.tar.gz"
  sha256 "1bf17678b8813fa12defa731e61c15145558b9f7f1296b0a6fdcfdda0caba468"
  license "ISC"
  compatibility_version 2
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1d53dcd0c49e4cfb0cedb3321c7a1f916813dbf66e6f23c240a2e031db8f551"
    sha256 cellar: :any, arm64_sequoia: "d01add37806a6c970d85d8896e9d5221c1215dca55d7bac01d2d015a88b5fd69"
    sha256 cellar: :any, arm64_sonoma:  "540ec7dd7206228014a5dbac953c2c68afe454fab4d0d6b1241a69d12b34208d"
    sha256 cellar: :any, sonoma:        "36bd290d3cb01e419aaf849c8eff3579dcb451c0babc95f0141e6dee4e350230"
    sha256 cellar: :any, arm64_linux:   "b2d449d3eaecec3dd414b0d92edcfab8d7c3d10f00d9aca4d97d56642f834975"
    sha256 cellar: :any, x86_64_linux:  "97d8cf1bc33a11ea3814069a870add8142a6038bf53af400abe2e278f4a25ebc"
  end

  depends_on "bmake" => :build

  patch do
    url "https://github.com/kristapsdz/lowdown/commit/5c44b2cf36e56a44bfdb3f974d11c3f96fc1b563.patch?full_index=1"
    sha256 "e5dc1625fc7b8b5d9c9fa70b0f2589cfa4ee4786be874d40104a7b82e08d0857"
    type :backport
    resolves "https://github.com/kristapsdz/lowdown/issues/185"
  end

  def install
    configure_args = %W[MANDIR=#{man} PREFIX=#{prefix}]
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      configure_args << "LINKER_SONAME=-install_name"
    end

    system "./configure", *configure_args
    system "bmake"
    system "bmake", "install", "install_libs"
  end

  test do
    expected_html = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <title></title>
      </head>
      <body>
      <h1 id="title">Title</h1>
      <p>Hello, World</p>
      </body>
      </html>
    HTML
    markdown = <<~MARKDOWN
      # Title

      Hello, World
    MARKDOWN
    html = pipe_output("#{bin}/lowdown -s", markdown)
    assert_equal expected_html, html
  end
end