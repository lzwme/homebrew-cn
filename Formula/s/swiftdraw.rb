class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https:github.comswhittySwiftDraw"
  url "https:github.comswhittySwiftDrawarchiverefstags0.18.0.tar.gz"
  sha256 "f29bfb19f1c89f1aa5b7eb15debd392d73f5617689c4acfba90b836eef5fa490"
  license "Zlib"
  revision 1
  head "https:github.comswhittySwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b1af94f7194c5bce47b32f14116166e56c2368f2f37e3c78cd85f2b0a6d94bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c3e7efbdd631764ac744a02931b78727e5dd60659a645f88d7b8d02e7da030"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6df270e63f5d958adc405d2ca4faeace9550626af82720a1d2ee99ef9a83de10"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddbd6b2b672551caf1fe9102decf996b83313aa3503ed0f7a0f1d691c719e91"
    sha256 cellar: :any_skip_relocation, ventura:       "3391d8f1906ff7cbf57e7a60d5cfb2a79f678c1ec31f74c5705a27242f1157aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a453b6d2bcba450f9e31d702a0847164f2470b9277a850e535ecd8312077e8ac"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".buildreleaseswiftdraw"
  end

  test do
    (testpath"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http:www.w3.org2000svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)">
      <svg>
    EOS
    system bin"swiftdraw", testpath"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath"fish-symbol.svg"
  end
end