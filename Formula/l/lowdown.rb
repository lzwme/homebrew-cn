class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-3.0.0.tar.gz"
  sha256 "c47b7208c941fadc6e646939bc548cc9a11f8bb22975b568c0249f78e78813b8"
  license "ISC"
  compatibility_version 1
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b31c45d3fd47ce40727517ceb3be4e8a0c3ded7a57b33dae452a730ee7369a6b"
    sha256 cellar: :any,                 arm64_sequoia: "2765c13d56937d87a46ac8305e16a54d78b3e8b7e0b15b9e6fe0c747e6d98a1b"
    sha256 cellar: :any,                 arm64_sonoma:  "c5c5f738954c801f39054208bb25212a1122a4e395847b9d352fa7758a601f85"
    sha256 cellar: :any,                 sonoma:        "fdbf9691d65225e2bd1bd906064fd2431782f60310a7f3f453ef00ce6bd6baf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e9e45beb17138e199b30b319c1697b7eaa156b64d9305ace914539be08968a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec94ee3c2483ab063257dc8438f5024805ce871ba5687eb51e1b32aa5e139dd7"
  end

  depends_on "bmake" => :build

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