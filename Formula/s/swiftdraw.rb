class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://ghfast.top/https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.28.1.tar.gz"
  sha256 "1f882249a98b4c22fdd13095f9c237680eba9c53c24bedbfb007e468d1665ed1"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4b3e0b47acd5a7fe5b47179ff3f80cfd5306b602f5acc4b0ba981e370e2f8d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3409339a9238b3501b294919c717c59eab35d704063473f32b44d62105b38b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7663c0af98ba2be29e1dcfa1df38d80709a00ef2c1a27e39e90d9f0e93276c7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6e745b947999d4a8ca3f51094fbd4fdc667d072e0e50a5ec5c91b25f36621d0"
    sha256 cellar: :any,                 arm64_linux:   "af5388fd5e9f67ea685713f2db8e81b6c226df4cf27ca451bb98dbad6ab8e910"
    sha256 cellar: :any,                 x86_64_linux:  "4b3c86fedf433ad91cc4d71e6ae8859cf4787433d8ac0c3ec6c811f4a0e9090f"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~SVG
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    SVG
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end