class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https:github.comswhittySwiftDraw"
  url "https:github.comswhittySwiftDrawarchiverefstags0.18.3.tar.gz"
  sha256 "a85c9fbd600f97a23055a41a258c6600338c7ac8e817ad03e0567f7d572587c5"
  license "Zlib"
  head "https:github.comswhittySwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b4b8e8323745eb9629303bca2eb0c502eca6d4dcf3aad503d157c4628d3a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1584d9f0e9bfaeccc1d679f0921404fa9ec3c0c9ef2301dddeaef9b5f2a05a74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3deb6e040c72346e1ac3a615b5a39845681c4db6c45f34008ea23fa38fe1788"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48b633a9da7e29150895f1932e58dd86a7a9eebdfb09b5f86b024d48c25c3a4"
    sha256 cellar: :any_skip_relocation, ventura:       "e487e85a5d23cfb226428695dffabfcff50aa672d0596574a45e71ddf28f365c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b286666af63c8d2568b2caa2692b10da28723268307dae7dbb6bebe480d34d"
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
    bin.install ".buildreleaseswiftdrawcli" => "swiftdraw"
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